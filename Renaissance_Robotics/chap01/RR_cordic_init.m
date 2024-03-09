% script RR_cordic_init
% This routine calculates cordic_tables, as used by the cordic routines.
% INPUT: (none)
% OUTPUT: cordic_tables.{K,ang,N}
% See RR_cordic.m and RR_cordic_core.m for how these tables are used.
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/RR_chap01
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

N=26;
% Generate data for the circular cordic routines.
Kbar = 1./sqrt(1+2.^(-(0:N-1)*2))
K  (1,:) = cumprod(Kbar);
ang(1,:) = atan(2.^-(0:N-1))
% Generate data for the hyperbolic cordic routines.
Kbar = 1./sqrt(1-2.^(-(1:N-2)*2))       % NOTE: iterations {4,13} are repeated
K  (2,:) = cumprod([Kbar(1:4) Kbar(4) Kbar(5:13) Kbar(13) Kbar(14:end)])
t = atanh(2.^-(1:24));
ang(2,:) = [t(1:4) t(4) t(5:13) t(13) t(14:end)];
% Print tables to the screen (so you can copy them to your MCU)
format long, K, ang, format short  
% Package tables for easy integration by Matlab subroutines.
cordic_tables.K = K;  cordic_tables.ang = ang;  cordic_tables.N = N;
clear N K Kbar ang t ans