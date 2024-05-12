function [out,s]=RR_MWC128_rev(n,s)
% function [out,s]=RR_MWC128_rev(n,s)
% PRNG using Vigna's tuning of Marsaglia's MWC128 scheme, marched in reverse
%      t←[c;x]; [x,c]←t/a; z←x^(x<<32);
% NOTE: {x,c} denoted {s(1),s(2)} in code below
% See RR_MWC for a convenient wrapper that takes care of state initialization. 
%
% INPUT:        n = number of pseudorandom numbers to generate
% INPUT/OUTPUT: s = vector of two uint64 state variables {x,c}
% OUTPUT:       out = vector of n uint64 ouputs
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

a128=RR_uint128(0xFFEBB71D94FCDAF9);
for i=1:n
  [Q,R]=RR_uint128(s(2),s(1))/a128; s(1)=Q.l; s(2)=R.l;
  out(i)=bitxor(s(1),bitsll(s(1),32));
end
