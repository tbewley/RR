function [out,s]=RR_xoshiro128pp(n,s)
% function [out,s]=RR_xoshiro128pp(n,s)
% PRNG using Blackman & Vigna's xoshiro128++ scheme (note: n,s are both required inputs)
% output computed with       z←((s0+s3)<<<7)+s0
% PRNG marched forward with  t←s1<<9, s2←s2^s0, s3←s3^s1, s1←s1^s2, s0←s0^s3, s2←s2^t, s3←s3<<<11
% NOTE: {s0,s1,s2,s3} denoted {s(1),s(2),s(3),s(4)} in code below
% See RR_xoshiro128 for a convenient wrapper that takes care of state initialization. 
% See https://prng.di.unimi.it/xoshiro128plusplus.c for Blackman & Vigna's C implementation.
%
% INPUT:        n = number of pseudorandom numbers to generate
% INPUT/OUTPUT: s = vector of four uint32 state variable 
% OUTPUT:       out = vector of n uint32 ouputs
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

for i=1:n
  out(i)=RR_sum32(RR_rotl32(RR_sum32(s(1),s(4)),7),s(1));       t=bitsll(s(2),9);
  s(3)=bitxor(s(3),s(1)); s(4)=bitxor(s(4),s(2)); s(2)=bitxor(s(2),s(3));
  s(1)=bitxor(s(1),s(4)); s(3)=bitxor(s(3),t );   s(4)=RR_rotl32(s(4),11);
end
