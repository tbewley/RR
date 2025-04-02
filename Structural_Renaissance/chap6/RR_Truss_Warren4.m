% script RR_Truss_Warren4.m
% Set up a Warren truss with 4 sections, solve for its internal forces, and plot
clear, P=[ 0  1;            % Locations of the fixed nodes of the truss (normalized units)
           0  0];
Q=[ 2  4  6  1  3  5  7;    % Locations of the free nodes of the truss
    0  0  0  2  2  2  2]/8;
U=[ 0  0  0  0  0  0  0;    % External forces on the free nodes of the truss (normalized)
    0 -1  0  0  0  0  0];     
CT=[ 1 -1  0  0  0  0  0  0  1  1  0  0  0  0  0;  % Connectivity of the truss
     0  1 -1  0  0  0  0  0  0  0  1  1  0  0  0;  % Note: each column of C^T has exactly
     0  0  1 -1  0  0  0  0  0  0  0  0  1  1  0;  % one entry equal to +1, and
     0  0  0  0 -1  0  0  1 -1  0  0  0  0  0  0;  % one entry equal to -1.
     0  0  0  0  1 -1  0  0  0 -1 -1  0  0  0  0;
     0  0  0  0  0  1 -1  0  0  0  0 -1 -1  0  0;
     0  0  0  0  0  0  1  0  0  0  0  0  0 -1 -1;
    -1  0  0  0  0  0  0 -1  0  0  0  0  0  0  0;
     0  0  0  1  0  0  0  0  0  0  0  0  0  0  1]; C=CT';
% Now, convert the D*X*CQ=U problem in (16.3a) to the standard A*x=u form in (16.3b)
[A,u]=RR_Convert_DXCQ_eq_U_to_Ax_eq_u(Q,P,C,U); 
% Then, solve for the tensile and compressive forces x in the truss, assuming no pretension
x=pinv(A)*u;         % This implements (16.4b)
% Finally, plot the truss (blue = tension, red = compression)
RR_Plot_Truss(Q,P,C,U,x);