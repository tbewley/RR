% script RR_frame_Signpost_in_Concrete.m
% First, determine the locations of the nodes of the Signpost (in meters)
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 5)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear
S.P=[]; S.R=[];  % No Pinned or Roller supports in this case
S.S=[ 0;         % Columns denote (x,y) locations of each of the s=1 Fixed support
      0];
S.Q=[ 0  0  0 -2  1;    % (x,y) locations of the n=5 free nodes
      2  3  4  3  3];   % (the second node makes the plot nice)
S.C=[ 0  0  1  1  0  0;
      1  0  0  0  1  0;
      0  0  1  0  1  0;
      1  1  1  0  0  1;
      0  1  0  1  1  0];
L.U=[ 0  0  0  0  0;   % External forces applied to each of the n=5 free nodes (in Newtons)
      0  0  0 -1  0];  
L.tension=[ 3 1];

% Convert the eqns for computing the interior forces to Ax=b, solve, and plot
[A,b,S,L]=RR_Structure_Analyze(S,L); x=pinv(A)*b;
figure(1); RR_Structure_Plot(S,L,x); error=norm(A*x-b)
