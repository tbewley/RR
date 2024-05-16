function [out,s]=RR_MWC128(n,s)
% function [out,s]=RR_MWC128(n,s)
% PRNG using Vigna's tuning of Marsaglia's MWC128 scheme (n,s are both required inputs)
%      z←x^(x<<32), t←x*a+c, [c;x]←t
% NOTE: {x,c} denoted {s(1),s(2)} in code below
% See RR_MWC for a convenient wrapper that takes care of state initialization. 
% See https://prng.di.unimi.it/MWC128.c for Vigna's C implementation.
%
% INPUT:        n = number of pseudorandom numbers to generate
% INPUT/OUTPUT: s = vector of two uint64 state variables {x,c}
% OUTPUT:       out = vector of n uint64 ouputs
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

for i=1:n
  out(i)=bitxor(s(1),bitsll(s(1),32)); [tl,th]=RR_prod64(s(1),0xFFEBB71D94FCDAF9);
  [s(2),s(1)]=RR_sum128(th,tl,0x0u64,s(2));
end
