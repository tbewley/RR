function [c_bars,t_strings,V]=TenSimStatics(Q,U,p,extra_constraints)
% Static equilibrium analysis of tensegrity structures with fixed nodes
% and external forces, assuming the tension in all tendons are measureable.
% If the conditions of static equilibrium are fully determined, solve for it.
% Otherwise (if the conditions of static equilibrium are underdetermined):
% a) determine whether or not the system is pretensionable
%    (with tau>=tau_min in all strings for u=zero). Then:
% b1) if system is pretensionable, find tensioning of the strings with
%    tau>=tau_min in all strings for applied U while minimizing w'*x_tilde, or
% b2) if the system is not pretensionable, find tensioning of the strings
%    that maximizes the minimum tension.
% Finally, compute the reaction forces V.
% By Thomas Bewley, UCSD and JPL (summer/fall 2019)
%
% For further explanation, see section 2.1 of B2019, which this code follows closely:
% Bewley (2019) Stabilization of low-altitude balloon systems, Part 2:
% riggings with multiple taut ground tethers, analyzed as tensegrity systems;
%
% INPUTS
% Q=Q_(dim x q)=locations of free nodes
% U=U_(dim x p)=applied external force vector at each free node
% p=constant parameters (see list below)
% extra_constraints=OPTIONAL argument, used if pulleys equilibrate 2 or more tether tensions
%
% PARAMETERS USED IN THIS FUNCTION THAT ARE PASSED IN WITH p:
C=p.C;         % C_(m x p)=connectivity matrix
P=p.P;         % P_(dim x p)=locations of fixed nodes
b=p.b_statics; % number of bars (including solid bodies modelled as bars)
c=p.c;         % number of isolated nodal points
s=p.s;         % number of strings
m=b+s;         % total number of members
dim=p.dim;     % dimension of system (2 or 3)
q=p.q;         % number of free nodes
p=p.p;         % number of fixed nodes (note: redefines p!)
n=p+q;         % total number of nodes
%
% OUTPUTS:
% c_bars     =magnitude of the compression force in each bar (neg for tension)
% t_strings  =magnitude of the tension force in each string (neg for compression)
% V_(dim x p)=reaction force vector at each fixed node

% First, set some default values
if nargin<4, extra_constraints=""; end 
% note: user might want to change the values below - maybe make them optional arguments?
tau_min=0.1;  % minimum tension (used in pretentionable case)
w=ones(m,1);  % weights used in weighted 1-norm (used in pretentionable case)

CQ=C(:,1:q); CP=C(:,q+(1:p));       % partition Connectivity matrix C
N=[Q P];                            % assemble Node matrix N
M=N*C'; B=M(:,1:b); S=M(:,b+(1:s)); % compute and partition Member matrix M, based on C and N
for i=1:m; D(:,i)=M(:,i)/norm(M(:,i)); end % direction vectors D(:,i)
x=sym('x',[1 m]); X=diag(x);        % set up (3a) in B2019 symbolically
sys=D*X*CQ-U;                       % note that sys=sys_(dim x q). We seek diagonal X s.t. sys=0.

% set up x1 to xm as symbolic variables, convert (3a) to (3b) [i.e., Ase*x=u]
for i=1:m; exp="syms x"+i; eval(exp); end  % set up a symbolic equationsToMatrix command in SYS
SYS='equationsToMatrix(['; for i=1:dim, for j=1:q, SYS=SYS+"sys("+i+","+j+")==0";
       if i<dim | j<q, SYS=SYS+","; end, end, end, SYS=SYS+extra_constraints+"],[";
for i=1:m, SYS=SYS+"x"+i; if i<m, SYS=SYS+","; end, end, SYS=SYS+"])";
[Ase,u]=eval(SYS);        % finally, execute the symbolic equationsToMatrix command assembled above
Ase=eval(Ase); u=eval(u); % convert Ase and u to a regular matrix and vector
mhat=dim*q; nhat=m;       % note that Ase=Ase_(mhat x nhat)
disp("Ase has mhat="+mhat+" equations.")
disp("Ase has nhat="+nhat+" unknowns.")

[U_,S_,V_]=svd(Ase); s_=diag(S_);                 % compute SVD of Ase (see sec 2.1.1 of B2019)
for i=1:length(s_); if s_(i)>1e-8; r=i; end, end, % determine rank of Ase
disp("Ase has rank="+r+".")
U_underbar=U_(:,1:r); U_overbar=U_(:,r+1:mhat); S_underbar=S_(1:r,1:r); % partition SVD
V_underbar=V_(:,1:r); V_overbar=V_(:,r+1:nhat); 
Ase_plus=V_underbar*inv(S_underbar)*U_underbar';  % determine pseudoinverse of Ase

if r<mhat
    disp('Warning: Ase is potentially inconsistent (rank<mhat).')
    disp('More strings or fixed points should fix the problem.')
else
    disp("Ase is not potentially inconsistent (r=mhat). Good.")
end, disp(' ')

disp('Bar compressions and string tensions with loads as specified,')
disp('LEAST SQUARES SOLUTION (i.e., NO pretensioning):')
x=Ase_plus*u; residual=norm(Ase*x-u);  % Solve Ase*x=u using pseudoinverse, check residual
if r<mhat
   if residual<1e-7,
       disp("u in column space of Ase, so at least one solution exists, with residual "+residual+".");
   else
       disp("u not in column space of Ase.  No solutions without deformation (residual "+residual+").]");
       c_bars=[]; t_strings=[]; V=[]; return
   end
end 
[c_bars,t_strings]=extract_tension_and_compression(x,b,s);

DOF=nhat-r; options = optimoptions('linprog','Display','none'); disp(' ')
if DOF>0
    disp("Ase is underdetermined with nhat-r="+DOF+" DOF. Checking now to see if system is pretensionable,");
    disp("with tension >= "+tau_min+" in all tethers for zero applied load."); disp(' ')
    
    % Start with x=0 solution, corresponding to u=0. System is pretentionable iff a
    % solution to the LP (5a)-(5b) exists with all strings in tension.
    V_tilde=V_overbar(b+1:b+s,:);
    w=ones(s,1); w_tilde=-V_tilde'*w; w_bar=[w_tilde; -w_tilde];
    A_bar=[-V_tilde V_tilde];      % Again, we are solving the LP in the u=0 case here.
    b_bar=-tau_min*ones(s,1);      % (We will redo this below for the specified u.)
    [c_bar,FVAL,exitflag]=linprog(-w_bar,A_bar,b_bar,[],[],[],[],options);
    if exitflag==1
        c=c_bar(1:DOF)-c_bar(DOF+1:2*DOF);
        disp('Result with EXTERNAL LOAD = ZERO, and PRETENSIONED WITH GIVEN TAU_MIN');
        disp('while minimizing the L1 norm of the tensions:');
        x0=V_overbar*c; [c_bars,t_strings]=extract_tension_and_compression(x0,b,s);
        
        pretensionable=true; disp('Pretensionable!'); disp(' ') % Section 2.1.4 of B2019
        disp('Results with EXTERNAL FORCES U AS SPECIFIED and PRETENSIONED WITH GIVEN TAU_MIN')
        disp('while minimizing the L1 norm of the tensions.');
        w=ones(s,1); w_tilde=-V_tilde'*w; w_bar=[w_tilde; -w_tilde];
        A_bar=[-V_tilde V_tilde];                      % Set up the LP in (5a)-(5b)
        b_bar=x(b+1:b+s)-tau_min*ones(s,1);            % to tension the strings
        c_bar=linprog(-w_bar,A_bar,b_bar,[],[],[],[],options);
        c=c_bar(1:DOF)-c_bar(DOF+1:2*DOF);
        x=x+V_overbar*c; [c_bars,t_strings]=extract_tension_and_compression(x,b,s);
    else
        pretensionable=false; disp('Not pretensionable!'); disp(' ') % Section 2.1.5 of B2019
        disp('Results with EXTERNAL FORCES U AS SPECIFIED and TENSIONED TO MAXIMIZE TAU_MIN:')
        w_bar=[zeros(2*DOF,1); 1];
        A_bar=[-V_tilde V_tilde ones(s,1)];                % Set up the modified LP in (5c)
        b_bar=x(b+1:b+s);                                  % to tension the strings
        [c_bar,FVAL,exitflag]=linprog(-w_bar,A_bar,b_bar,[],[],[],[],options);
        c=c_bar(1:DOF)-c_bar(DOF+1:2*DOF);
        x=x+V_overbar*c; [c_bars,t_strings]=extract_tension_and_compression(x,b,s);
        if exitflag==1; disp('Tensionable under this loading profile!');
        else,           disp('Not tensionable under this loading profile.'); end
    end
else
    disp("Ase is not underdetermined (nhat=r); thus, it is not tensionable. The above solution is unique.")
end
V=D*diag(x)*CP;  % Compute reaction forces at fixed points.
end % function TenSimStatics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [c_bars,t_strings]=extract_tension_and_compression(x,b,s)
c_bars(1:b)=-x(1:b)
if min(c_bars)>=0, disp("No bars under tension.  Good.");
else, disp("Note: some bars not under compression.  Maybe replace them with strings?"), end
t_strings(1:s)=x(b+(1:s)), tau_min=min(t_strings);
if min(t_strings)>0, disp("The "+s+" strings are all under tension with tau_min="+tau_min+". Good."),
else, disp("Some strings not under tension. Needs different tensioning or external loads."), end
end % function extract_tension_and_compression
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
