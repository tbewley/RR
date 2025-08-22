% script RR_frame_Fireplace_Tongs4_SLOW_WAY.m
% This code sets up and solves the forces in some fireplace tongs.  The SLOW, BUGGY WAY...
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, Chapter 3)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, clc

% x={fCAx fCAy fCGx fCGy fCBx fCBy fDAx fDAy fDGx fDGy fDBx fDBy}
 A=[  1    0    0    0    0    0    1    0    0    0    0    0;
      0    1    0    0    0    0    0    1    0    0    0    0;
      0    0    0    0    1    0    0    0    0    0    1    0;
      0    0    0    0    0    1    0    0    0    0    0    1;
     -1    0   -1    0   -1    0    0    0    0    0    0    0;
      0   -1    0   -1    0   -1    0    0    0    0    0    0;
      0    0    0    0    0    0   -1    0   -1    0   -1    0;
      0    0    0    0    0    0    0   -1    0   -1    0   -1;
     -h    0    0    0    0    0    h    0    0    0    0    0;
      0    0    0    0   -h    0    0    0    0    0    h    0;
      s    c    0    0   -s   -c    0    0    0    0    0    0;
      0    0    0    0    0    0    s    c    0    0   -s   -c]
  b=[ 0  -fyA   0  -fyB   0    0    0    0 lA*fyA -lB*fyB 0  0]', pause

% Convert the eqns for computing the interior forces to Ax=b, solve, and plot.
[A,b,S,L]=RR_Structure_Analyze(S,L); x=pinv(A)*b;    
figure(2); RR_Structure_Plot(S,L,x); error=norm(A*x-b)