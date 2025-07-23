% script RR_Frame_4_Bar_Seesaw.m
% Locations of the fixed nodes of the truss (normalized units)

lA=0.5; lB=1;   % Locations of the masses
fyA=-1; fyB=-1; % Values of the externally-applied forces
phi=10;         % Deflection of the frame, in degrees
c=cosd(phi); s=sind(phi); % (intermediate variables)
h=1; w=2;       % Parameters defining the physical frame

P=[ 0  0;       % Columns denote (x,y) locations of each of the p=2 pinned supports
    0 2*h];
                % Locations of each of the n=10 free nodes (below)
Q=[-w*c -w*c       w*c  w*c     -w*c   -w*c*1.5 -w*c-lA  w*c   w*c*1.5  w*c+lB;
    w*s  w*s+2*h  -w*s -w*s+2*h  w*s+h  w*s+h   w*s+h  -w*s+h -w*s+h   -w*s+h ];
U=[ 0  0  0  0  0  0  0  0  0  0;    % External forces on the n free nodes
    0  0  0  0  0  0 fyA 0  0 fyB];  
   % m=4 members (columns) 
CT=[ 1 0 0 1;  % q_1   Connectivity of the pin-jointed frame
     1 0 1 0;  % q_2   Note: members may connect 3 or more nodal points
     0 1 0 1;  % q_3   (and, thus, may bear internal bending loads!), and 
     0 1 1 0;  % q_4   each node may have 3 or more members attached in
     1 0 0 0;  % q_5   addition to having a applied external load.
     1 0 0 0;  % q_6 
     1 0 0 0;  % q_7
     0 1 0 0;  % q_8 
     0 1 0 0;  % q_9 
     0 1 0 0;  % q_10 
     0 0 0 1;  % p_1   
     0 0 1 0]; % p_2
C=CT';

% Now, convert the linear eqns for computing the interior forces in the frame
% into standard A*x=u form
[A,b]=RR_Convert_Frame_to_Ax_eq_b(Q,C,U,P); 
% Then, solve for the interior and reaction forces in the frame
x=pinv(A)*b, error=norm(A*x-b)
figure(1); clf
% if error>1e-8, disp('No equilibrium solution'), else, RR_Plot_Frame(Q,C,U,x,P), end
RR_Plot_Frame(Q,C,U,x,P)