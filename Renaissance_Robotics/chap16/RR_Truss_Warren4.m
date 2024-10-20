% script RR_Truss_Warren4.m
% Sets up a Warren truss with 4 sections, solves for its forces, and plots
P=[ 0  1;                     % Fixed nodes
    0  0];
Q=[ 2  4  6  1  3  5  7;      % Free nodes
    0  0  0  2  2  2  2]/8;
U=[ 0  0  0  0  0  0  0;      % External forces
    0 -1  0  0  0  0  0];     % on the free nodes
C=[ 1 -1  0  0  0  0  0  0  1  1  0  0  0  0  0;  % Connectivity
    0  1 -1  0  0  0  0  0  0  0  1  1  0  0  0;
    0  0  1 -1  0  0  0  0  0  0  0  0  1  1  0;
    0  0  0  0 -1  0  0  1 -1  0  0  0  0  0  0;
    0  0  0  0  1 -1  0  0  0 -1 -1  0  0  0  0;
    0  0  0  0  0  1 -1  0  0  0  0 -1 -1  0  0;
    0  0  0  0  0  0  1  0  0  0  0  0  0 -1 -1;
   -1  0  0  0  0  0  0 -1  0  0  0  0  0  0  0;
    0  0  0  1  0  0  0  0  0  0  0  0  0  0  1]';
% The following converts the D*X*CQ=U problem to a standard A*x=u form
[A,u]=RR_Convert_DXCQ_eq_U_to_Ax_eq_u(Q,P,U,C); 
% Now, solve for the forces x in the truss, assuming no preconditioning
x=pinv(A)*u; % elements of x: positive=tension, negative=compression
% Then plot the truss, with blue=tension, red=compression, black=no force
RR_Plot_Truss(Q,P,U,C);
