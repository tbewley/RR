function [out,s]=RR_xoroshiro128ss_rev(n,s)
% function [out,s]=RR_xoroshiro128ss_rev(n,s)
% PRNG using Blackman & Vigna's xoroshiro128** scheme, marched in reverse
% PRNG advanced with     s1←(s1>>>37),  s0←(s0^s1^(s1<<16))>>>24,  s1←s1^s0
% output computed with   z←((s0*5)<<<7)*9
% NOTE: {s0,s1} denoted {s(1),s(2)} in code below
% See RR_xoroshiro128 for a convenient wrapper that takes care of state initialization. 
% 
% INPUT:        n = number of pseudorandom numbers to generate
% INPUT/OUTPUT: s = vector of two uint64 state variable 
% OUTPUT:       out = vector of n uint64 ouputs
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

for i=1:n
  s(2)=RR_rotr64(s(2),37);
  s(1)=RR_rotr64(bitxor(bitxor(s(1),s(2)),bitsll(s(2),16)),24);
  s(2)=bitxor(s(2),s(1));
  out(i)=RR_prod64s(RR_rotl64(RR_prod64s(s(1),0x5u64),7),0x9u64); 
end
