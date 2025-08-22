% script RR_truss_Warren4.m
% Set up a Warren truss with 4 sections, solve for its internal forces, and plot
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 6)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

P=[ 0  1;   % Columns denote (x,y) locations of each of the p=2 fixed nodes (normalized)
    0  0];
Q=[ 2  4  6  1  3  5  7;    % Locations of each of the n=7 free nodes (normalized)
    0  0  0  2  2  2  2]/8;
U=[ 0  0  0  0  0  0  0;    % External forces on the n free nodes of the truss (normalized)
    0 -1  0  0  0  0  0];     
CT=[ 1 -1  0  0  0  0  0  0  1  1  0  0  0  0  0;  % Connectivity of the truss
     0  1 -1  0  0  0  0  0  0  0  1  1  0  0  0;  % Note: each of the m=15 columns of C^T
     0  0  1 -1  0  0  0  0  0  0  0  0  1  1  0;  % (that is, each of the m=15 rows of C)
     0  0  0  0 -1  0  0 -1 -1  0  0  0  0  0  0;  % has exactly one entry equal to +1
     0  0  0  0  1 -1  0  0  0 -1 -1  0  0  0  0;  % and one entry equal to -1, indicating
     0  0  0  0  0  1 -1  0  0  0  0 -1 -1  0  0;  % which two nodes that that member 
     0  0  0  0  0  0  1  0  0  0  0  0  0 -1 -1;  % connects. It doesn't matter which is
    -1  0  0  0  0  0  0  1  0  0  0  0  0  0  0;  % taken positive and which negative.
     0  0  0  1  0  0  0  0  0  0  0  0  0  0  1]; C=CT';
% Now, convert the D*X*CQ=U problem in (6.3a) to the standard A*x=u form in (6.3b)
[A,b]=RR_Convert_DXCQ_eq_U_to_Ax_eq_b(Q,P,C,U); 
% Then, just solve for the tension and compression in the members, and plot.
x=pinv(A)*b                % This just implements (6.4b),  Assumes zero pretension!
RR_Plot_Truss(Q,P,C,U,x);  % Plot truss (red=positive=tension, blue=negative=compression)
