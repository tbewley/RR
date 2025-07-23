% script RR_Frame_Scissor_Lift.m
% First, determine the locations of the nodes of the scissor lift (in meters)
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 5)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

L=1; phi=65, L1=0.2*L; L2=0.05*L; P2x=0.35*L; P2y=-0.25*L;
W=L*cosd(phi); H=L*sind(phi);
P=[ 0 P2x;  % Columns denote (x,y) locations of each of the p=2 Pinned supports
    0 P2y];
R=[ W;      % (x,y) location of the r=1 Roller support
    0];    
Q=[ L1*cosd(phi)-L2*sind(phi) L1*cosd(phi) W/2 W 0;  % (x,y) locations of the n=5 free nodes
    L1*sind(phi)+L2*cosd(phi) L1*sind(phi) H/2 H H]; % (the second node makes the plot nice)
U=[ 0  0  0   0    0;   % External forces applied to each of the n=5 free nodes (in Newtons)
    0  0  0 -500 -500];  
   % The m=3 structural Members of this pin-jointed frame are defined in the columns of CT.
CT=[ 1 1 0;  % q_1   Each structural member connects several (Q,P,R) nodes of the frame, 
     0 1 0;  % q_2   as indicated by the 1's in the corresponding columns at left.
     0 1 1;  % q_3   Note: each structural member may connect 3 or more nodal points
     0 1 0;  % q_4   (and, thus, each structural member may bear internal bending loads), 
     0 0 1;  % q_5   and each node may have 3 or more strucural members attached,
     0 1 0;  % p_1   in addition to having an externally applied load (defined in U).
     1 0 0;  % p_2
     0 0 1]; % r_1
% Now, convert the linear eqns for determining the static equilibrium of the frame into the
% standard A*x=u form.  Note that these equations of static equilbrium are just the following:
%   (a) the sum of forces on each pin = zero,
%   (b) the sum of forces on each structural member = zero, and 
%   (c) the sum of moments on each structural member = zero.
C=CT';  [A,b]=RR_Convert_Frame_to_Ax_eq_b(Q,C,U,P,R); 
% Then, solve for the interior forces in the frame, assuming no pretensioning.
x=pinv(A)*b; error=norm(A*x-b)
if error>1e-8, disp('No equilibrium solution'), else, RR_Plot_Frame(Q,C,U,x,P,R), end