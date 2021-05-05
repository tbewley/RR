function cordic_tables=cordic_init
% function cordic_tables=cordic_init
% This routine calculates the tables used by the cordic routines.
% INPUT: (none)
% OUTPUT: cordic_tables.{K,ang,N}
% See cordic.m and cordic_core.m for how these tables are used.
% Renaissance Robotics codebase, Chapter 1, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under Modified BSD License.

N=26;
% Generate data for the circular cordic routines.
K  (1,:) = cumprod(1./abs(1+i*2.^(-(0:N-1))));  % NOTE: i=sqrt(-1)
ang(1,:) = atan(2.^-(0:N-1))
% Generate data for the hyperbolic cordic routines.
t = sqrt(1-2.^(-(1:N-2)*2));       % NOTE: iterations {4,13} are repeated
K  (2,:) = cumprod([t(1:4) t(4) t(5:13) t(13) t(14:end)])
t = atanh(2.^-(1:24));
ang(2,:) = [t(1:4) t(4) t(5:13) t(13) t(14:end)];
% Print tables to the screen (so you can copy them to your MCU)
format long, K, ang, format short  
% Package tables for easy integration by Matlab subroutines.
cordic_tables.K = K;  cordic_tables.ang = ang;  cordic_tables.N = N;
