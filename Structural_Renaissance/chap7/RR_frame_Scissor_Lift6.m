% script RR_frame_Scissor_Lift6.m
% This script simulates the action of a medium scissor lift (3 pairs of crossed MFMs, and
% a piston TFM that drives it).  The code is quite similar to those of the firplace tongs.
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 5)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, global RR_VERBOSE, RR_VERBOSE=0; figure(1); clf, 
Length=1; L1=0.2*Length; L2=0.05*Length; P2x=0.45*Length; P2y=-0.05*Length; load=1000;
fprintf('Load =%0.0f N\n',load); w=-load/2;
for phi=10:2.5:80
  W=Length*cosd(phi); H=Length*sind(phi);
  S.P=[ 0;  % Columns denote (x,y) locations of each of the p=2 Pinned supports
        0];
  S.R=[ W;      % (x,y) location of the r=1 Roller support
        0];    
  S.Q=[ L1*cosd(phi)-L2*sind(phi) L1*cosd(phi) W/2 W 0;  % (x,y) locations of the n=5 free nodes
        L1*sind(phi)+L2*cosd(phi) L1*sind(phi) H/2 H H]; % (the second node makes the plot nice)
  L.U=[ 0 0 0 0 0;   % External forces applied to each of the n=5 free nodes (in Newtons)
        0 0 0 w w];  
  S.C=[ 1 0 0 0 0 0 0 0;
        1 1 1 1 0 1 0 0;
        0 0 1 0 1 0 0 1];

  % Convert the eqns for computing the interior forces to Ax=b, solve, and plot
  [A,b,S,L]=RR_Structure_Analyze(S,L); x=pinv(A)*b;
  RR_Structure_Plot(S,L,x); axis([-0.1 1.02 -0.12 1.05]), 
  piston_length=norm(S.Q(:,1)-S.P(:,2)); piston_compression=abs(x(1)); 
  fprintf('phi=%0.1f deg, piston_length=%0.3f m, piston_compression=%0.1f N\n',phi,piston_length,piston_compression)
  pause(0.1); 
end