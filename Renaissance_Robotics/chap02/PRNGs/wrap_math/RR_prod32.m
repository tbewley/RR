function p32=RR_prod32(a,b)
% function p32=RR_prod32(a,b)
% Defines a*b with wrap on integer overflow, for {a,b}=uint32, using uint64 arithmetic
% NOTE: replace calls to this function with a simple * if converting to a language
% that can be set to natively wrap on integer overflow!
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

p32=uint32(bitand(uint64(a)*uint64(b),0xFFFFFFFFu64));   % p32=lower 32 bits of a*b
