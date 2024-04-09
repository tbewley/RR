function [ph,pl]=RR_prod128(y,z,a)
% function [ph,pl]=RR_prod128(y,z,a)
% Computes x*a with wrap on integer overflow, for xh=y and xl=z and {y,z,a}=uint64,
% where {xh,xl} and {ph,pl} are the high and low 64 bits of x and p, respectively.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

al=bitand(a,0xFFFFFFFFu64); ah=bitsra(a,32); % {al,ah}={lower,upper} 32 bits of a
yl=bitand(y,0xFFFFFFFFu64); yh=bitsra(y,32); % {bl,bh}={lower,upper} 32 bits of y
zl=bitand(z,0xFFFFFFFFu64); zh=bitsra(z,32); % {bl,bh}={lower,upper} 32 bits of z

... TODO: pick it up from here...

pl=RR_sum64(al*bl,bitsll(RR_sum64(al*bh,ah*bl),32));

% drop the carry part (wrap on overflow)
