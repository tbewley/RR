function p64=RR_prod64s(a,b)
% function p64=RR_prod64s(a,b)
% Defines a*b with wrap on integer overflow, for {a,b}=uint64
% This is a SIMPLIFIED version RR_prod64, assuming b is zero in its upper 32 bits.
% NOTE: replace calls to this function with a simple * if converting to a language
% that can be set to natively wrap on integer overflow!
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

al=bitand(a,0xFFFFFFFFu64); ah=bitsra(a,32); % {al,ah}={lower,upper} 32 bits of a
p64=RR_sum64(al*b,bitsll(ah*b,32));  % drop the carry part (wrap on overflow)
