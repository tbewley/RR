function p64=RR_prod64(a,b)
% function p64=RR_prod64(a,b)
% Defines a*b with wrap on integer overflow, for {a,b}=uint64, using uint64 arithmetic
% NOTE: replace calls to this function with a simple * if converting to a language
% that can be set to natively wrap on integer overflow!
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

al=bitand(a,0xFFFFFFFFu64); ah=bitsra(a,32); % {al,ah}={lower,upper} 32 bits of a
bl=bitand(b,0xFFFFFFFFu64); bh=bitsra(b,32); % {bl,bh}={lower,upper} 32 bits of b
p64=RR_sum64(al*bl,bitsll(RR_sum64(al*bh,ah*bl),32));  % drop the carry part (wrap on overflow)
