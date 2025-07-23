% script RR_Truss_Whipple10.m
% Set up a Whipple truss with 10 sections, solve for its internal forces, and plot
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 6)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

P=[ 0  1;   % Columns denote (x,y) locations of each of the p=2 fixed nodes (normalized)
    0  0];
h=2.2; m=-1;
Q=[ 1 2 3 4 5 6 7 8 9 1 2 3 4 5 6 7 8 9;    % Locations of each of the n=7 free nodes (normalized)
    0 0 0 0 0 0 0 0 0 h h h h h h h h h]/10;
U=[ 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;    % External forces on the n free nodes of the truss (normalized)
    0 0 0 0 m 0 0 0 0 0 0 0 0 0 0 0 0 0];
% Connectivity of the truss. Each of the m=39 rows of has one entry equal to 1 and one equal to m.
% Note that there are n=q+p=18+2=20 columns of C, corresponding to the 20 nodes N=[Q P].
C=[ 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 m 0; % bottom row (10)
    m 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 m 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 m 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 m 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 m 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 m 1 0 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 m 1 0 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 m 1 0 0 0 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 m 0 0 0 0 0 0 0 0 0 0 1;
    0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 m 0; % far left diagonal
    0 0 0 0 0 0 0 0 0 m 1 0 0 0 0 0 0 0 0 0; % top row (8)
    0 0 0 0 0 0 0 0 0 0 m 1 0 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 m 1 0 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 m 1 0 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 m 1 0 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 m 1 0 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 m 1 0 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 m 1 0 0;
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 m 0 1; % far right diagonal
    1 0 0 0 0 0 0 0 0 m 0 0 0 0 0 0 0 0 0 0; % verticals (10)
    0 1 0 0 0 0 0 0 0 0 m 0 0 0 0 0 0 0 0 0;
    0 0 1 0 0 0 0 0 0 0 0 m 0 0 0 0 0 0 0 0;
    0 0 0 1 0 0 0 0 0 0 0 0 m 0 0 0 0 0 0 0;
    0 0 0 0 1 0 0 0 0 0 0 0 0 m 0 0 0 0 0 0;
    0 0 0 0 0 1 0 0 0 0 0 0 0 0 m 0 0 0 0 0;
    0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 m 0 0 0 0;
    0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 m 0 0 0;
    0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 m 0 0;
    0 1 0 0 0 0 0 0 0 m 0 0 0 0 0 0 0 0 0 0; % left short inner diagonal
    0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 m 0 0; % right short inner diagonal
    0 0 m 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0; % left inner diagonals
    0 0 0 m 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0; 
    0 0 0 0 m 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0; 
    0 0 0 0 0 m 0 0 0 0 0 0 1 0 0 0 0 0 0 0;
    0 0 0 0 0 0 m 0 0 0 0 0 0 0 0 0 0 1 0 0; % right inner diagonals
    0 0 0 0 0 m 0 0 0 0 0 0 0 0 0 0 1 0 0 0;
    0 0 0 0 m 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0;
    0 0 0 m 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0];
% Now, convert the D*X*CQ=U problem in (6.3a) to the standard A*x=u form in (6.3b)
[A,b]=RR_Convert_DXCQ_eq_U_to_Ax_eq_b(Q,P,C,U); 
% Then, just solve for the tension and compression in the members, and plot.
x=pinv(A)*b                % This just implements (6.4b),  Assumes zero pretension!
RR_Plot_Truss(Q,P,C,U,x);  % Plot truss (red=positive=tension, blue=negative=compression)
