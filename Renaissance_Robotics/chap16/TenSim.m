function TenSim(structure,sym)
% TenSim performs static equilibrium analysis and dynamic simulation of several types of tensegrity
% systems, possibly including fixed nodes, external forces, and embedded solid bodies.
% By Thomas Bewley, UCSD and JPL (summer/fall 2019)
%
% Example calling convention (using Matlab 2017b or later): TenSim('S1',3), TenSim('T3',6), etc.
%
% The 16 structures implemented in this code thus far (try them all!) are:
% Balloon+payload riggings (from Bewley 2019):
%   'S1','S2','S3','S4','S5','S6'  Stable designs     (try sym=3 or 4)
%   'C1','C2','C3'                 Cliff-spanning designs
%   'W1','W2','W3'                 "Wobbly" designs   (try sym=3 or 4, or try sym=2 for W1)
% A few other test cases (from Skelton & de Oliviera 2009)
%   'T1' 2D TBar of Fig 3.3
%   'T2' 3D TBar of Fig 3.15
%   'T3' 2D Mitchell truss of, e.g., Fig 4.4          (try order=3 to 8)
%   'T4' 3D prism of, e.g., Fig 3.28 and 3.43         (try sym=3, 4, or 5)
%
% NOTE: dynamics portion of code only developed for class=1 tensegrity structures (so far!)

%%%%%%% SOME ADDITIONAL INPUT PARAMETERS YOU MIGHT WANT TO ADJUST ARE DEFINED BELOW %%%%%%% 
p.az=19; p.el=14;         % Default 3D view
g=9.8; p.T=100; p.h=0.05; % Gravitational acceleration, simulation time, and timestep.
switch structure
    case {'S1','S2','S3','S4','S5','S6','W1','W2','W3'} %%%%% STABLE AND WOBBLY BALLOON+PAYLOAD RIGGINGS %%%%%
        p.kappa=3000;                        % stiffness of the strings [see eqn (6) in B2019]
        Radius_b=2; Radius_p=1; Radius_g=20; % Radius of balloon, payload, and ground nodes.
        Hp=30;                               % Height of payload
        switch structure                   % Height of balloon and, if applicable, convergence point
            case {'S6','W1','W2'}, Hb=36; Hc=32;  
            case {'W3'},           Hb=40; Hc=32;  
            otherwise,             Hb=34;
        end
        off=[0; 0];                % Horizontal center of balloon/payload system
        psi=0;                     % Extra rotation of payload & balloon
        Bdisturb=50; Pdisturb=0;   % Horizontal disturance force on balloon and payload, in Newtons
        p.ma(1)=10; p.ma(2)=20;    % Mass of payload and balloon, in kg
    case {'C1','C2','C3'}  %%%%% CLIFF-SPANNING BALLOON+PAYLOAD RIGGINGS %%%%%  
        p.kappa=1000;                      
        Radius_b=80; Radius_p=60;      % Radius of balloon and payload
        Hp=1900; Hb=2200;              % Height of payload and balloon
        switch structure
            case {'C1'}, psi=pi/16;  off=[2300; -400]; sym=3; % psi = Extra rotation of payload & balloon
            case {'C2'}, psi=pi/3;   off=[2200; -330]; sym=3; % off = Horizontal center of balloon/payload system
            case {'C3'}, psi=5*pi/8; off=[2200; -330]; sym=4; % (sym in these three cases is hard-wired)            
        end
        Bdisturb=-200; Pdisturb=0;     % Horizontal disturance force on balloon and payload, in Newtons
        p.ma(1)=50; p.ma(2)=100;       % Mass of payload and balloon, in kg
        p.p=sym; p.T=1000; p.h=0.25;   % choose some different simulation parameters
    case {'T1'}            %%%%% 2D TBar %%%%% 
        p.kappa=1000;
    case {'T2'}            %%%%% 3D TBar %%%%%
        p.kappa=1000; p.az=15; p.el=8; % choose a different default view
    case {'T3'}            %%%%% 2D Mitchell truss %%%%%  
        p.kappa=1000; phi=pi/12, beta=pi/6, r=1, 
    case {'T4'}            %%%%% 3D prism %%%%%
        p.kappa=100;  rt=1, rb=1, h=1,       
        % For the "twist angle" alpha of the prism, a couple of special values are computed below.
        % alpha1 gives the "minimal prism" (with zero tension on the "diagonal" strings)
        % alpha2 gives equal tension on the "diagonal" and "vertical" strings
        % [Note: (3.66) in Skelton & de Oliviera 2009 is tension density, not tension.]
        alpha1=pi/2-pi/sym;
        switch sym, case 3, alpha2=pi/3; case 4, alpha2=1.3310; case 5, alpha2=1.4007; end
        alpha=alpha2;                    % Select which alpha to use here (try different values!)
        disp("Need "+r2d(pi/2-pi/sym)+" <= alpha <= "+r2d(pi/2));
end
plot_with_forces=true;    % put arrows on static analysis plot (true or false)
%%%%%%%%%%%%%%%%%%%%%%%%% END OF ADDITIONAL ADJUSTABLE PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%

% set up TenSimStateClass and define the class of the tensegrity structure under consideration.
p.structure=structure;  x=TenSimStateClass; 
switch p.structure
    case {'T1'}, class=4;
    case {'T2'}, class=5;
    case {'T3'}, class=2;
    otherwise,   class=1;
end

% DEFINE p.a SOLID BODIES (Ra,Radot,Da,Oa,etc)
switch p.structure
    case {'S1','S2','S3','S4','S5','S6','C1','C2','C3','W1','W2','W3'}
        p.a=2;                    % number of solid bodies (body #1 is payload, body #2 is balloon)
        p.na(1)=sym; p.na(2)=sym; % number of nodal points on each solid body (1..a)
        
        % Ja(1:3,1:b)=principle moments of each solid body, with J(1,k)>=J(2,k)>=J(3,k)>0 for k=1..a
        p.Ja(1,  1)=(2/12)*p.ma(1)*Radius_p^2;  % Assume a (roughly) plate-like payload,
        p.Ja(2:3,1)=(1/12)*p.ma(1)*Radius_p^2;
        p.Ja(1:3,2)=(2/5) *p.ma(2)*Radius_b^2;   % and a (nearly) spherical balloon
        
        % Ra(1:3,1:a)=nominal locations of the center of mass of each solid body
        % Da(1:4,1:a)=unit quaternions describing the nominal orientation of
        %             each solid body, as a rotation from its principle coordinates.
        x.Ra(1:3,1)=[off(1) off(2) Hp]; x.Ra(1:3,2)=[off(1) off(2) Hb]; % Payload and Balloon nominal locations.
        x.Da(1:4,1)=quat_def_rotation(pi/2,[0 1 0]);  % Payload nominally rotated about e^2 by -pi/2 radians.
        switch p.structure                            % Align payload and balloon for these cases.
            case {'S6','W1','W3'}, x.Da(1:4,1)=quat_multiply(quat_def_rotation(pi/sym,[0 0 1]),x.Da(1:4,1));
        end
        x.Da(1:4,2)=quat_def_rotation(pi/sym,[0 0 1]);  % Balloon nominally rotated about e^3 by pi/sym radians.
        % QaB(1:a)=non-rectangular (cell) array, each entry QaB{k}(1:3,1:na(k)) of which is a
        % matrix containing the locations of the na(k) nodal points on solid body k in Body coordinates
        for i=1:sym
            phi=2*pi*(i-1)/sym+psi;
            p.QaB{1}(1:3,i)=[0; Radius_p*cos(phi); Radius_p*sin(phi)]; % payload
            p.QaB{2}(1:3,i)=[Radius_b*sin(phi); Radius_b*cos(phi); 0];  % balloon
        end
    otherwise
        p.a=0;                 % Number of solid bodies
end
if p.a==0,  x.Radot=[];            x.Oa=[];
else        x.Radot(1:3,1:p.a)=0;  x.Oa(1:3,1:p.a)=0;  end

% DEFINE p.b BARS (Rb,Rbdot,Db,Hb,etc)
switch p.structure
    case {'T1'}
        % In these test cases, for simplicity, we will just define the node locations Q directly
        % (will need to define things quite differently if attempting dynamics of class>1 structures!)
        Q(1:2,1:5)=[0 1 2 1 1; 0 0 0 .5 -.5];     p.b=4;
    case {'T2'}
        Q(:,1)=[0; 0; 0];
        Q(:,2)=[1; 0; 0];
        Q(:,3)=[2; 0; 0]; r=0.5;
        Q(:,4)=[1; r*cos(0);      r*sin(0)];
        Q(:,5)=[1; r*cos(2*pi/3); r*sin(2*pi/3)];
        Q(:,6)=[1; r*cos(4*pi/3); r*sin(4*pi/3)]; p.b=5;
    case {'T3'}
        a=sin(beta)/sin(beta+phi); c=sin(phi)/sin(beta+phi);
        m=1; for i=0:sym-1, for j=-i:2:i
                Q(:,m)=r*[cos(phi*j) sin(phi*j)]; m=m+1;
            end, r=a*r; end,                      p.b=(sym+1)*sym/2;
    case {'T4'}
        phi=2*pi/sym; p.b=sym; p.mb(1:p.b)=1;
        for k=1:sym
            Q(1:3,2*k-1)=[rb*cos(k*phi)           rb*sin(k*phi)           -h/2];
            Q(1:3,2*k)  =[rt*cos((k+1)*phi+alpha) rt*sin((k+1)*phi+alpha) h/2];
        end
        for k=1:sym
            x.Rb(:,k)=(Q(:,2*k-1)+Q(:,2*k))/2; x.Db(:,k)=Q(:,2*k-1)-Q(:,2*k);
            p.ellb(k)=norm(x.Db(:,k));         x.Db(:,k)=x.Db(:,k)/p.ellb(k);
            p.Jb(k)=p.mb(k)*p.ellb(k)^2/12;
        end
    otherwise
        p.b=0;                   % Number of (actual) bars
end
if p.b==0, x.Rbdot=[];           x.Hb=[];
else       x.Rbdot(1:3,1:p.b)=0; x.Hb(1:3,1:p.b)=0; end

% DEFINE p.c ISOLATED NODAL POINTS (Rc,Rcdot,etc)
switch p.structure
    case {'S6','W1','W2','W3'}, p.c=1; p.mc(1)=1; x.Rc(1:3,1)=[0 0 Hc];
    otherwise,                  p.c=0;
end
if p.c==0,  x.Rcdot=[];            
else        x.Rcdot(1:3,1:p.c)=0;                   end

% DEFINE LOCATIONS OF FREE NODES Q_(p.dim x p.q) AND FIXED NODES p.P_(p.dim x p.p)
if class==1, Q=TenSimComputeQ(x.Ra,x.Da,x.Rb,x.Db,x.Rc,p); end % Find the nominal locations of free nodes
[p.dim,p.q]=size(Q);
switch p.structure
    case {'S1','S2','S3','S4','S5','S6','W1','W2','W3'}
        for i=1:sym
            phi1=(2*pi*(i-1)+pi)/sym; phi=2*pi*(i-1)/sym;
            switch p.structure                                           % set 1 
                case {'S3','W1'}, p.P(1:3,i)=[Radius_g*sin(phi +pi/sym); Radius_g*cos(phi +pi/sym); 0];
                otherwise,        p.P(1:3,i)=[Radius_g*sin(phi1+pi/sym); Radius_g*cos(phi1+pi/sym); 0];
            end
            switch p.structure                                           % set 2
                case {'S4'},      p.P(1:3,sym+i)=[Radius_g*sin(phi +pi/sym); Radius_g*cos(phi +pi/sym); 0]; 
                case {'S5','W2'}, p.P(1:3,sym+i)=[Radius_p*sin(phi1+pi/sym); Radius_p*cos(phi1+pi/sym); 0];
                case {'W1'},      p.P(1:3,sym+i)=[Radius_p*sin(phi +pi/sym); Radius_p*cos(phi +pi/sym); 0];
            end
        end, p.p=size(p.P,2);
    case {'C1'}
        p.P(1:3,1)=[2785; -768.8; 1998];   % high
        p.P(1:3,2)=[1594; -623.8; 1340];   % low
        p.P(1:3,3)=[2299;  121.6; 2018];   % high
    case {'C2'}
        p.P(1:3,1)=[2061; -765.6; 1555];   % low
        p.P(1:3,2)=[1344; -280.2; 1344];   % low
        p.P(1:3,3)=[2528; -166.2; 2077];   % high
    case {'C3'}
        p.P(1:3,1)=[2061; -765.6; 1555];   % low
        p.P(1:3,2)=[1344; -280.2; 1344];   % low
        p.P(1:3,3)=[2299;  121.6; 2018];   % high
        p.P(1:3,4)=[2785; -768.8; 1998];   % high
    case {'T3'}
        m=1; for j=-sym:2:sym
            p.P(:,m)=r*[cos(phi*j) sin(phi*j)]; m=m+1;
        end, p.p=size(p.P,2);
    otherwise
        p.p=0; p.P=[];
end
p.n=p.q+p.p;

% DEFINE CONNECTIVITY p.CB, p.CS, p.C
switch p.structure
    case {'T1'}
        p.CB(1,1)=1; p.CB(1,2)=-1;    p.CS(1,1)=1; p.CS(1,4)=-1;
        p.CB(2,2)=1; p.CB(2,3)=-1;    p.CS(2,4)=1; p.CS(2,3)=-1;
        p.CB(3,2)=1; p.CB(3,4)=-1;    p.CS(3,3)=1; p.CS(3,5)=-1;
        p.CB(4,2)=1; p.CB(4,5)=-1;    p.CS(4,5)=1; p.CS(4,1)=-1;
    case {'T2'}
        p.CB(1,1)=1; p.CB(1,2)=-1;    p.CS(1,1)=1; p.CS(1,4)=-1;
        p.CB(2,2)=1; p.CB(2,3)=-1;    p.CS(2,1)=1; p.CS(2,5)=-1;
        p.CB(3,2)=1; p.CB(3,4)=-1;    p.CS(3,1)=1; p.CS(3,6)=-1;
        p.CB(4,2)=1; p.CB(4,5)=-1;    p.CS(4,3)=1; p.CS(4,4)=-1;
        p.CB(5,2)=1; p.CB(5,6)=-1;    p.CS(5,3)=1; p.CS(5,5)=-1;
        p.CS(6,3)=1; p.CS(6,6)=-1;
        p.CS(7,4)=1; p.CS(7,5)=-1;
        p.CS(8,5)=1; p.CS(8,6)=-1;
        p.CS(9,6)=1; p.CS(9,4)=-1;
    case {'T3'}
        m=1; for k=1:sym, for j=m:m+k-1,
             p.CB(m,j)=1; p.CB(m,j+k)=-1;  p.CS(m,j)=1; p.CS(m,j+k+1)=-1;
        m=m+1; end; end
    case {'T4'}
        for i=1:sym, j=mod(i,sym)+1; l=mod(i-2,sym)+1;
            p.CB(      i,2*i-1)=1; p.CB(      i,2*i)=-1;    % bars
            p.CS(      i,2*i-1)=1; p.CS(      i,2*j-1)=-1;  % bottom strings
            p.CS(  sym+i,2*i  )=1; p.CS(  sym+i,2*j)=-1;    % top strings
            p.CS(2*sym+i,2*i-1)=1; p.CS(2*sym+i,2*l)=-1;    % "vertical" strings
        end
        if alpha>alpha1
            disp("Consider here a nonminimal case with alpha="+r2d(alpha)+", WITH diagonal strings")
            for i=1:sym, m=mod(i-3,sym)+1;
                p.CS(3*sym+i,2*i-1)=1; p.CS(3*sym+i,2*m)=-1;
            end
        else
            disp("Consider here the minimal case with alpha="+r2d(alpha)+", NO diagonal strings")
        end
    case {'S1','S2','S3','S4','S5','S6','C1','C2','C3','W1','W2','W3'}
        j1=sym*(sym-1)/2; m1=1; for i=1:sym, j=mod(i,sym)+1; k=mod(i-2,sym)+1; l=mod(i-3,sym)+1;
            for j=i+1:sym
                p.CB(   m1,    i)=1; p.CB(   m1,    j)=-1;          % bars modelling payload
                p.CB(j1+m1,sym+i)=1; p.CB(j1+m1,sym+j)=-1; m1=m1+1; % bars modelling balloon
            end
            switch p.structure
                case {'S6','W1','W2','W3'}
                    p.CS(    i,sym+i)=1; p.CS(    i,2*sym+1)=-1; % strings from balloon to convergence point
                    p.CS(sym+i,    i)=1; p.CS(sym+i,2*sym+1)=-1; % strings from convergence point to payload
                otherwise
                    p.CS(    i,sym+i)=1; p.CS(    i,      k)=-1; % strings from balloon to payload (set 1)
                    p.CS(sym+i,sym+i)=1; p.CS(sym+i,      i)=-1; % strings from balloon to payload (set 2)
            end
            m2=2*sym; switch p.structure                          % strings from balloon to ground
                case {'S3','W1'}, p.CS(m2+    i,sym+i)=1; p.CS(m2+    i,p.q+k)=-1; m2=3*sym;
                case {'W3'}       % NONE in this case!
                otherwise,        p.CS(m2+    i,sym+i)=1; p.CS(m2+    i,p.q+k)=-1;           % (set 1)
                                  p.CS(m2+sym+i,sym+i)=1; p.CS(m2+sym+i,p.q+l)=-1; m2=4*sym; % (set 2)
            end
            switch p.structure                                   % strings from payload to ground
                case {'S2'},           p.CS(m2+    i,i)=1; p.CS(m2+    i,p.q+k)=-1;
                case {'S3'},           p.CS(m2+    i,i)=1; p.CS(m2+    i,p.q+i)=-1;     % (set 1)
                                       p.CS(m2+sym+i,i)=1; p.CS(m2+sym+i,p.q+k)=-1;     % (set 2)
                case {'S4'},           p.CS(m2+    i,i)=1; p.CS(m2+    i,p.q+sym+i)=-1; % (set 1)
                                       p.CS(m2+sym+i,i)=1; p.CS(m2+sym+i,p.q+sym+k)=-1; % (set 2)
                case {'S5','W1','W2'}, p.CS(m2+    i,i)=1; p.CS(m2+    i,p.q+sym+k)=-1;
                case {'S6','W3'},      p.CS(m2+    i,i)=1; p.CS(m2+    i,p.q+k)=-1;     % (set 1)
                                       p.CS(m2+sym+i,i)=1; p.CS(m2+sym+i,p.q+l)=-1;     % (set 2)
            end
        end
        switch p.structure           % extra (individual) string(s) from payload to ground
            case {'C1'}, p.CS(13,3)=1; p.CS(13,8)=-1;
            case {'C2'}, p.CS(13,3)=1; p.CS(13,8)=-1;
                         p.CS(14,2)=1; p.CS(14,7)=-1;
            case {'C3'}, p.CS(17,2)=1; p.CS(17, 9)=-1; 
                         p.CS(18,3)=1; p.CS(18,10)=-1;  
        end
        
end
[p.b_statics,t1]=size(p.CB); [p.s,t2]=size(p.CS); p.m=p.b_statics+p.s; % NOTE: p.b_statics includes the bars modeling
p.C=[p.CB zeros(p.b_statics,t2-t1); p.CS zeros(p.s,t1-t2)];            % the bodies in the static analysis

% DEFINE EXTERNAL FORCING ON BARS, BODIES (nominal and disturbance)
switch p.structure
    % If class>1, we do static analysis only, so just define forces on the nodes directly.
    case {'T1'}
        U_nodes(1:2,1:5)=[1 0 -1.6 .3 .3; 0 0 0 0 0];
    case {'T2'}
        U_nodes(1:3,1:6)=[1 0 -1 0 0 0; 0 0 0 0 0 0; 0 0 0 0 0 0];
    case {'T3'}
        U_nodes(1:2,1:p.q)=0; U_nodes(1:2,1)=[0; -1];
    case {'T4'}
        for k=1:p.q/2; U_nodes(:,2*k-1)=[0; 0; 1]; U_nodes(:,2*k)=[0; 0; -1]; end
        Ub_disturbance=-x.Rb*1;  Ua_disturbance=[];
    case {'S1','S2','S3','S4','S5','S6','C1','C2','C3','W1','W2','W3'}
        % In these cases, first define forces on bodies and bars...
        Ua_nominal(1:3,1)=[0; 0; -p.ma(1)*g];      % nominal force on payload
        Ua_nominal(1:3,2)=[0; 0;  p.ma(2)*g];      % nominal force on balloon
        Ua_disturbance(1:3,1)=[0; Pdisturb; 0];    % disturbance force on payload
        Ua_disturbance(1:3,2)=[0; Bdisturb; 0];    % disturbance force on balloon
        Ua=Ua_nominal;
        switch p.structure                              % Forces at convergence point
            case {'S6','W1','W2','W3'}, Uc(1:3,1)=0;
            otherwise,                  Uc=[];
        end
        % ...then extract corresponding (nominal) forces at nodes
        m=0; for k=1:p.a, for i=1:p.na(k), U_nodes(:,m+i)=Ua(:,k)/p.na(k); end, m=m+p.na(k); end
        for k=1:p.c,                       U_nodes(:,m+k)=Uc(:,k);                           end
end

% SOLVE FOR FORCES IN STATIC EQUILIBRIUM, in nominal configuration with nominal load
[c_bars,t_strings,V]=TenSimStatics(Q,U_nodes,p);
if size(t_strings)==0, return, end

% PLOT THE NOMINAL STRUCTURE
figure(1), clf
if plot_with_forces, switch p.structure
        case {'S1','S2','S3','S4','S5','S6','W1','W2','W3'}
            TenSimPlot(Q,p,U_nodes,V,false,1,4)
        case {'C1','C2','C3'}
            TenSimPlot(Q,p,U_nodes,V,false,.5,20)
        case {'T1'}
            TenSimPlot(Q,p,U_nodes,V,true,2.0)
        case {'T2'}
            TenSimPlot(Q,p,U_nodes,V,true,1,0.08)
        case {'T3'}
            TenSimPlot(Q,p,U_nodes,V,true,0.1,0.08)
        case {'T4'}
            TenSimPlot(Q,p,U_nodes,V,true,0.5,0.12)
end, else, TenSimPlot(Q,p), end, grid on, 

% SIMULATE THE DYNAMICS OF THE PERTURBED STRUCTURE
if class==1
    switch p.structure
        case {'S1','S2','S3','S4','S5','S6','C1','C2','C3','W1','W2','W3'} % For these cases, perturb the loaded structure
            % First, compute the nominal string lengths that give these equilibrium forces.
            S=[Q p.P]*p.CS';
            for i=1:p.s, p.ells0(i)=p.kappa*norm(S(:,i))/(t_strings(i)+p.kappa); end
            % Then, add the (constant, for now...) disturbance forcing, and simulate the dynamics
            Ua=Ua_nominal+Ua_disturbance; Ub=[];
        otherwise % For other cases, for simplicity, just perturb the unloaded structure.
            Ua=Ua_disturbance; Ub=Ub_disturbance; S=[Q p.P]*p.CS'; for i=1:p.s, p.ells0(i)=norm(S(:,i)); end
    end
    disp(' '), disp('Now rotate figure to desired viewpoint for the dynamic simulation, and press return.')
    pause, [p.az,p.el]=view; disp('(Hit CTRL-C to exit dynamic simulation.)')  % Set new (user-defined) 3D viewpoint
    TenSimDynamics(x,Ua,Ub,p)
end
end % function TenSim
%%%%%%%%%%%%%%%%%%%%%%%%%%%% END OF MAIN SCRIPT TenSim %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function phi1=r2d(phi)  % convert radians to degrees
phi1=phi*180/pi;
end % function r2d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
