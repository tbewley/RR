% script RR_Truss_Weird.m
% Set up a Weird truss with 4 sections, solve for its internal forces, and plot
clear, P=[ 0  1;            % Locations of the fixed nodes of the truss (normalized units)
           0  0];
Q=[.5 .5   .25  .75  .5;    % Locations of the free nodes of the truss
    0 .866 .433 .433 .289];
U=[ 0  0  0  0  0;    % External forces on the free nodes of the truss (normalized)
    -1 0  0  0  0];     
C=[1 0 0 0 0 -1 0;
   1 0 0 0 0 0 -1;
   0 0 1 0 0 -1 0;
   0 -1 1 0 0 0 0;
   0 1 0 -1 0 0 0;
   0 0 0 1 0 0 -1;
   0 0 1 0 -1 0 0;
   0 0 0 1 -1 0 0;
   1 0 0 0 -1 0 0];
% Now, convert the D*X*CQ=U problem in (16.3a) to the standard A*x=u form in (16.3b)
[A,b]=RR_Convert_DXCQ_eq_U_to_Ax_eq_b(Q,P,C,U); 
% Then, solve for the tensile and compressive forces x in the truss, assuming no pretension
x=pinv(A)*b;         % This implements (16.4b)
% Finally, plot the truss (blue = tension, red = compression)
x
rank(A)
RR_Plot_Truss(Q,P,C,U,x);