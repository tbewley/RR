function [out,s]=RR_MWC256(n,s)
% function [out,s]=RR_MWC256(n,s)
% PRNG using Vigna's tuning of Marsaglia's MWC256 scheme (n,s are both required inputs)
%      ouput=z, t←x*a+c, x←y, y←z, [c;z]←t
% NOTE: {x,y,z,c} denoted {s(1),s(2),s(3),s(4)} in code below
% See RR_MWC for a convenient wrapper that takes care of state initialization. 
% See https://prng.di.unimi.it/MWC128.c for Vigna's C implementation.
%
% INPUT:        n = number of pseudorandom numbers to generate
% INPUT/OUTPUT: s = vector of four uint64 state variables {x,y,z,c}
% OUTPUT:       out = vector of n uint64 ouputs
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

for i=1:n
  out(i)=s(3); [tl,th]=RR_prod64(s(1),0xFFA04E67B3C95D86); s(1)=s(2); s(2)=s(3);
  [s(4),s(3)]=RR_sum128(th,tl,0x0u64,s(4));
end
