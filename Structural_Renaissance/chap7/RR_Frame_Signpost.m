% script RR_frame_Signpost.m
% First, determine the locations of the nodes of the Signpost (in meters)
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 5)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear
S.P=[ 0 2;  % Columns denote (x,y) locations of each of the p=2 Pinned support
      0 0];
S.Q=[ 0  0  0 -2  1;   % (x,y) locations of the n=5 free nodes
      2  3  4  3  3];  
L.U=[ 0  0  0  0  0;   % External forces applied to each of the n=5 free nodes (in Newtons)
      0  0  0 -1  0];  
S.C=[ 1  0  0  0  0  0  1;
      0  0  1  1  0  0  0;
      1  0  0  0  1  0  0;
      1  1  1  0  0  1  0;
      0  1  0  1  1  0  0];

% Convert the eqns for computing the interior forces to Ax=b, solve, and plot
[A,b,S,L]=RR_Structure_Analyze(S,L); x=pinv(A)*b;
S.P_in=[true false];
figure(2); RR_Structure_Plot(S,L,x); error=norm(A*x-b)
