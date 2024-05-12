function [out,s]=RR_MWC128_rev(n,s)
% function [out,s]=RR_MWC128_rev(n,s)
% PRNG using Vigna's tuning of Marsaglia's MWC128 scheme, marched in reverse
%      t←[c;y], y←x, [x,c]←t/a, output=y
% NOTE: {x,y,c} denoted {s(1),s(2),s(3)} in code below
% See RR_MWC for a convenient wrapper that takes care of state initialization. 
%
% INPUT:        n = number of pseudorandom numbers to generate
% INPUT/OUTPUT: s = vector of two uint64 state variables {x,c}
% OUTPUT:       out = vector of n uint64 ouputs
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

a128=RR_uint128(0xFFA04E67B3C95D86);
for i=1:n
  [Q,R]=RR_uint128(s(3),s(2))/a128; s(2)=s(1); s(1)=Q.l; s(3)=R.l;
  out(i)=s(2);
end
