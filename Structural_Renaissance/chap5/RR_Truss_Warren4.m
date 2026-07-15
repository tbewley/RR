% script RR_truss_Warren4.m
% Set up a Warren truss with 4 sections, solve for its internal forces, and plot
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 6)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE
clear; close all; figure(1)
global RR_VERBOSE, RR_VERBOSE=2
S.P=[0  1;   % Columns denote (x,y) locations of each of the p=2 fixed nodes (normalized)
     0  0];
S.Q=[2  4 6 1 3 5 7;    % Locations of each of the q=7 free nodes (normalized)
     0  0 0 2 2 2 2]/8;
L.U=[0  0 0 0 0 0 0;    % External forces on the q=7 free nodes of the truss (normalized)
     0 -1 0 0 0 0 0];     
S.C=[1  1 0 0 0 0 0 0 1 1 0 0 0 0 0;   % Connectivity of the truss
     0  1 1 0 0 0 0 0 0 0 1 1 0 0 0;   % Note: each of the m=15 columns of C^T
     0  0 1 1 0 0 0 0 0 0 0 0 1 1 0;   % (i.e., each of the m=15 rows of C)
     0  0 0 0 1 0 0 1 1 0 0 0 0 0 0;   % has exactly two entries equal to +1,
     0  0 0 0 1 1 0 0 0 1 1 0 0 0 0;   % indicating which two nodes (of the
     0  0 0 0 0 1 1 0 0 0 0 1 1 0 0;   % n=q+p=9 nodes) that that member
     0  0 0 0 0 0 1 0 0 0 0 0 0 1 1;   % connects. Note: the RR_Strructure_Analyze 
     1  0 0 0 0 0 0 1 0 0 0 0 0 0 0;   % code automatically converts exactly one of  
     0  0 0 1 0 0 0 0 0 0 0 0 0 0 1]'; % the two nonzero entries per row of C to -1
% Now, convert the D*X*CQ=U problem in (5.3a) to the standard A*x=u form in (5.3b)
[A,b,S,L]=RR_Structure_Analyze(S,L); % Then, solve for the forces in the members, and plot.
x=pinv(A)*b; error_norm=norm(A*x-b)  % This just implements (5.4b), assuming zero pretension.
RR_Structure_Plot(S,L,x)      % Plot truss (red=positive=tension, blue=negative=compression)
