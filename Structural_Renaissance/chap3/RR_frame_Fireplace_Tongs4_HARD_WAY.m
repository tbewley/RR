% script RR_frame_Fireplace_Tongs4_HARD_WAY.m
% This code sets up and solves the forces in some fireplace tongs.  The HARD WAY...
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 3)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, clc
phi=20; s=sind(phi); c=cosd(phi); 
fxA=0; fxB=0; fyB=10; fyA=-fyB;

% x={f1x f1y f2x f2y f3x f3y f4x f4y fCx fCy fDx fDy}
 A=[  1   0   0   0   1   0   0   0   0   0   0   0;
      0   1   0   0   0   1   0   0   0   0   0   0;
      0   0   0   0   s   c   0   0   0   0   0   0;
      1   0   1   0   0   0   0   0   0   0   0   0;
      0   1   0   1   0   0   0   0   0   0   0   0;
      0   0  -s   c   0   0   0   0   0   0   0   0;
      0   0   1   0   0   0   1   0   0   0   1   0;
      0   0   0   1   0   0   0   1   0   0   0   1;
      0   0  -s  -c   0   0   0   0   0   0   s   c;
      0   0   0   0  -1   0  -1   0   1   0   0   0;
      0   0   0   0   0  -1   0  -1   0   1   0   0;
      0   0   0   0  -s   c   0   0  -s   c   0   0]
  b=[-fxA -fyA s*fxA+c*fyA fxB fyB s*fxB-c*fyB 0 0 0 0 0 0]', pause

x=A\b, error=norm(A*x-b)