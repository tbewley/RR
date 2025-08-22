% script RR_frame_Fireplace_Tongs6.m
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 5)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, global RR_VERBOSE, RR_VERBOSE=1
S.P=[10 10;  % Columns denote (x,y) locations of each of the p=2 pinned supports
      1 -1]; S.P_vec=[0 0; 1 -1];
S.Q=[-2  -2   0  2  2  4  6  6  8;    % Locations of each of the n=6 free nodes
      1  -1   0  1 -1  0 -1  1  0];
L.U=[-.5 -.5  0  0  0  0  0  0  0;    % External forces on the n free nodes
     -1   1   0  0  0  0  0  0  0];  
S.C=[ 1   0   1  0  1  0  0  0  0  0  0; % Connectivity of the pin-jointed frame
      0   1   1  1  0  0  0  0  0  0  0; % Note: members may connect 3 or more nodal points,
      0   0   0  0  1  1  0  1  0  0  0; % and nodes may have 3 or more members attached,
      0   0   0  1  0  1  1  0  0  0  0; % in addition to having an applied external load
      0   0   0  0  0  0  0  1  1  0  1;
      0   0   0  0  0  0  1  0  1  1  0];

% Convert the eqns for computing the interior forces to Ax=b, solve, and plot
[A,b,S,L]=RR_Structure_Analyze(S,L); x=pinv(A)*b;
figure(2); RR_Structure_Plot(S,L,x); error=norm(A*x-b)

