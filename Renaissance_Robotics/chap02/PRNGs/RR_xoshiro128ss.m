function [out,s]=RR_xoshiro128ss(n,s)
% function [out,s]=RR_xoshiro128ss(n,s)
% PRNG using Blackman & Vigna's xoshiro128** scheme (note: n,s are both required inputs)
% output computed with       z←((s1*5)<<<7)*9
% PRNG marched forward with  t←s1<<9, s2←s2^s0, s3←s3^s1, s1←s1^s2, s0←s0^s3, s2←s2^t, s3←s3<<<11
% NOTE: {s0,s1,s2,s3} denoted {s(1),s(2),s(3),s(4)} in code below
% See RR_xoshiro128 for a convenient wrapper that takes care of state initialization. 
% See https://prng.di.unimi.it/xoshiro128starstar.c for Blackman & Vigna's C implementation.
%
% INPUT:        n = number of pseudorandom numbers to generate
% INPUT/OUTPUT: s = vector of four uint32 state variable 
% OUTPUT:       out = vector of n uint32 ouputs
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

for i=1:n
  out(i)=RR_prod32(RR_rotl32(RR_prod32(s(2),0x5u32),7),0x9u32);     % two multiplications
  t=bitsll(s(2),9);
  s(3)=bitxor(s(3),s(1)); s(4)=bitxor(s(4),s(2)); s(2)=bitxor(s(2),s(3));    % five XORs
  s(1)=bitxor(s(1),s(4)); s(3)=bitxor(s(3),t );   s(4)=RR_rotl32(s(4),11);
end

disp('THERE IS STILL A BUG IN THIS ONE.')
