% script RR_frame_Signpost3D.m
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 5)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear; 
S.P=[ 0 1.5 1.5; % Columns denote (x,y,z) locations of each of the p=3 pinned support nodes
      0  1  -1;
      0  0   0]; d=3; p=3; 
S.Q=[ 0  0 -2  1  0  0;   % (x,y,z) locations of the q=6 free nodes
      0  0  0  0  1 -1;
      3  4  3  3  3  3]; q=4; n=q+p; m=16;
S.C=[ 0  0  0  0  1  0  0  1  0;  % C is m x n = 15 x 9
      0  0  0  0  0  1  0  0  1;
      0  0  0  1  0  0  0  1  0;
      0  0  0  1  0  0  0  0  1;
      0  1  0  1  0  0  0  0  0;
      0  1  1  0  0  0  0  0  0;
      0  0  1  0  1  0  0  0  0;
      0  0  1  0  0  1  0  0  0;
      0  0  0  1  1  0  0  0  0;
      0  0  0  1  0  1  0  0  0;
      0  1  0  0  1  0  0  0  0;
      0  1  0  0  0  1  0  0  0;
      1  0  0  0  1  1  0  0  0;
      1  1  0  0  0  0  1  0  0;
      1  0  1  1  0  0  0  0  0]; 

% FIRST, apply the nominal load with pretensions, and compute internal forces
L.U=[ 0  0  0  0  0  0;   % External forces applied to each of the q=4 free nodes (in Newtons)
      0  0  0  0  0  0;
      0  0 -1  0  0  0];
L.tension=[ 1 1; 6 3; 7 1; 10 1; 11 1];
% Convert the eqns for computing the interior forces to Ax=b, solve, and plot
[A,b,S,L]=RR_Structure_Analyze(S,L); x_pre=pinv(A)*b;
figure(1); S.P_in=[true false false]; RR_Structure_Plot(S,L,x_pre); error=norm(A*x_pre-b)

% THEN, apply the disturbance loads, and compute additional internal forces
clear L
L.U=[ 0  0 -.2  0  0  0;   % External forces applied to each of the q=4 free nodes (in Newtons)
      0  0 -.2  0  0  0;
      0  0  0  0  0  0];
[A,b,S,L]=RR_Structure_Analyze(S,L); x_dist=pinv(A)*b;

% In figure 2, we add (by linearity) the internal forces due to the nominal load with pretensions
% to the additional internal forces due to the disturbance loads
figure(2); x=x_pre+x_dist; RR_Structure_Plot(S,L,x); error=norm(A*x-b)
