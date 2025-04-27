% script RR_Frame_Scissor_Lift.m
% Locations of the fixed nodes of the scissor lift (normalized units)
L=1; phi=70; L1=0.2*L; L2=0.05*L; P2x=0.35*L; P2y=-0.25*L;
W=L*cosd(phi); H=L*sind(phi);
P=[ 0 P2x;  % Columns denote (x,y) locations of each of the p=2 Pinned supports
    0 P2y];
R=[ W;  % Columns denote (x,y) locations of each of the p=2 Roller supports
    0];    
Q=[ L1*cosd(phi)-L2*sind(phi) L1*cosd(phi) W/2 W 0;  % Locations of the n=4 free nodes
    L1*sind(phi)+L2*cosd(phi) L1*sind(phi) H/2 H H]; % (the second node makes the plot nice)
U=[ 0  0 0  0    0;
    0  0 0 -0.2 -0.2];  
   % m=3 members (columns) 
CT=[ 1 1 0;  % q_1   Connectivity of the nodes (Q,P,R) of the pin-jointed frame
     0 1 0;  % q_2   Note: members may connect 3 or more nodal points
     0 1 1;  % q_3   (and, thus, may bear internal bending loads!), and 
     0 1 0;  % q_4   (and, thus, may bear internal bending loads!), and 
     0 0 1;  % q_5   each node may have 3 or more members attached in
     0 1 0;  % p_1   addition to having a applied external load.
     1 0 0;  % p_2
     0 0 1]; % r_1
% Now, convert the linear eqns for computing the interior forces in the frame
% into standard A*x=u form
C=CT';  [A,b]=RR_Convert_Frame_to_Ax_eq_b(Q,C,U,P,R); 
% Then, solve for the interior forces in the frame
x=pinv(A)*b; error=norm(A*x-b)
if error>1e-8, disp('No equilibrium solution'), else, RR_Plot_Frame(Q,C,U,x,P,R), end
