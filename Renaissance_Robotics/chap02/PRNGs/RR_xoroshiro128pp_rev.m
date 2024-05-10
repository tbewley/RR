function [out,s]=RR_xoroshiro128pp_rev(n,s)
% function [out,s]=RR_xoroshiro128pp_rev(n,s)
% PRNG using Blackman & Vigna's xoroshiro128++ scheme, marched in reverse
% PRNG marched in reverse with     s1←(s1>>>28),  s0←(s0^s1^(s1<<21))>>>49,  s1←s1^s0,
% output computed with             z←((s0+s1)<<<17)+s0
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
  s(2)=RR_rotr64(s(2),28);
  s(1)=RR_rotr64(bitxor(bitxor(s(1),s(2)),bitsll(s(2),21)),49);
  s(2)=bitxor(s(2),s(1));
  out(i)=RR_sum64(RR_rotl64(RR_sum64(s(1),s(2)),17),s(1));
end
