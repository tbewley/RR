function [out,s]=RR_xoshiro128ss_rev(n,s)
% function [out,s]=RR_xoshiro128ss_rev(n,s)
% PRNG using Blackman & Vigna's xoshiro128** scheme, marched in reverse
% PRNG marched in reverse with  s3←s3>>>11, q←s1, r←s1^s2, s0←s0^s3, s1←Shift32(r), s2←q^s1, s3←s3^s1
% output computed with          z←((s1*5)<<<7)*9
% NOTE: {s0,s1,s2,s3} denoted {s(1),s(2),s(3),s(4)} in code below
% See RR_xoshiro128 for a convenient wrapper that takes care of state initialization. 
%
% INPUT:        n = number of pseudorandom numbers to generate
% INPUT/OUTPUT: s = vector of four uint32 state variable 
% OUTPUT:       out = vector of n uint32 ouputs
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

for i=1:n
  s(4)=RR_rotr32(s(4),11); q=s(2); r=bitxor(s(2),s(3)); s(1)=bitxor(s(1),s(4));
  s(2)=RR_shift32(r); s(3)=bitxor(bitxor(q,s(2)),s(1)); s(4)=bitxor(s(4),s(2));
  out(i)=RR_prod32(RR_rotl32(RR_prod32(s(2),0x5u32),7),0x9u32);                                   
end
