% script RR_Frame_Fireplace6.m
% Locations of the fixed nodes of the truss (normalized units) 
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 5)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

P=[10  10;  % Columns denote (x,y) locations of each of the p=2 pinned supports
    1 -1];
Q=[ -2  -2   0  2  2  4  6  6  8;    % Locations of each of the n=6 free nodes
     1  -1   0  1 -1  0 -1  1  0];
U=[-0.4 -0.4 0  0  0  0  0  0  0;    % External forces on the n free nodes
    -1   1   0  0  0  0  0  0  0];  
   % m=4 members (columns) 
CT=[ 1 0 0 0 0 0;  % q_1   Connectivity of the pin-jointed frame
     0 1 0 0 0 0;  % q_2   Note: members may connect 3 or more nodal points
     1 1 0 0 0 0;  % q_3   (and, thus, may bear internal bending loads!), and 
     0 1 0 1 0 0;  % q_4   each node may have 3 or more members attached in
     1 0 1 0 0 0;  % q_5   addition to having a applied external load.
     0 0 1 1 0 0;  % q_6 
     0 0 0 1 0 1;  % q_7 
     0 0 1 0 1 0;  % q_8 
     0 0 0 0 1 1;  % q_9 
     0 0 0 0 0 1;  % p_1
     0 0 0 0 1 0]; % p_2
C=CT';

% Now, convert the linear eqns for computing the interior forces in the frame
% into standard A*x=u form
[A,b]=RR_Convert_Frame_to_Ax_eq_b(Q,C,U,P); 
% Then, solve for the interior forces in the frame
x=pinv(A)*b; error=norm(A*x-b)
if error>1e-8, disp('No equilibrium solution'), else, RR_Plot_Frame(Q,C,U,x,P), end

