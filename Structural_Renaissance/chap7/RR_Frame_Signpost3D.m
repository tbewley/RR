% script RR_Frame_Signpost3D.m
% First, determine the locations of the nodes of the Signpost (in meters)
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 5)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

P=[ 0 1.5  1.5;  % Columns denote (x,y,z) locations of each of the p=3 Pinned support
    0  1   -1;
    0  0    0]
Q=[ 0 0 -2 1;   % (x,y,z) locations of the n=4 free nodes
    0 0  0 0;
    3 4  3 3];  
U=[ 0 0 .2 0;   % External forces applied to each of the n=4 free nodes (in Newtons)
    0 0 .2 0;
    0 0 -1 0];  
   % The m=8 structural Members of this pin-jointed frame are defined in the columns of CT.
CT=[ 1 1 0 0 0 1 1 0;  % q_1   Each structural member connects several (Q,P,R) nodes of the frame,
     0 0 1 0 0 1 0 1;  % q_2   as indicated by the 1's in the corresponding columns at left.
     0 0 0 0 0 0 1 1;  % q_3   Note: each structural member may connect 3 or more nodal points 
     0 0 1 1 1 0 1 0;  % q_4   (and, thus, each structural member may bear internal bending loads),
     0 0 0 0 0 1 0 0;  % p_1   and each node may have 3 or more strucural members attached,
     1 0 0 1 0 0 0 0;  % p_2   in addition to having an externally applied load (defined in U).
     0 1 0 0 1 0 0 0]; % p_3
% Now, convert the linear eqns for determining the static equilibrium of the frame into the
% standard A*x=u form.  Note that these equations of static equilbrium are just the following:
%   (a) the sum of forces on each pin = zero,
%   (b) the sum of forces on each structural member = zero, and 
%   (c) the sum of moments on each structural member = zero.
C=CT';  [A,b]=RR_Convert_Frame_to_Ax_eq_b(Q,C,U,P); 
% Then, solve for the interior forces in the frame, assuming no pretensioning.
x=pinv(A)*b; error=norm(A*x-b)
if error>1e-8, disp('No equilibrium solution'), else, RR_Plot_Frame(Q,C,U,x,P), end