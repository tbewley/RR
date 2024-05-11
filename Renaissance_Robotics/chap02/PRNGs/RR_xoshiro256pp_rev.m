function [out,s]=RR_xoroshiro256pp_rev(n,s)
% function [out,s]=RR_xoroshiro256pp_rev(n,s)
% PRNG using Blackman & Vigna's xoroshiro256++ scheme, marched in reverse
% PRNG marched in reverse with s3←s3>>>45, q←s1, r←s1^s2, s0←s0^s3, s1←Shift64(r), s2←q^s1, s3←s3^s1
% output computed with         z←((s0+s3)<<<23)+s0
% NOTE: {s0,s1,s2,s3} denoted {s(1),s(2),s(3),s(4)} in code below
% See RR_xoroshiro256 for a convenient wrapper that takes care of state initialization. 
%
% INPUT:        n = number of pseudorandom numbers to generate
% INPUT/OUTPUT: s = vector of four uint64 state variable 
% OUTPUT:       out = vector of n uint64 ouputs
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

for i=1:n
  s(4)=RR_rotr64(s(4),45); q=s(2); r=bitxor(s(2),s(3)); s(1)=bitxor(s(1),s(4));
  s(2)=RR_Shift64_slow(r); s(3)=bitxor(q,s(2));         s(4)=bitxor(s(4),s(2));
  out(i)=RR_sum64(RR_rotl64(RR_sum64(s(1),s(4)),23),s(1));                                 
end
