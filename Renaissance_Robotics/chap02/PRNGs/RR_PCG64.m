function [out,x]=RR_PCG64(n,x,c)
% function [out,x]=RR_PCG64(n,x,c)        (n,x,c are required inputs) 
% PRNG using O'Neill's PCG64 scheme, DXSM (double xor shift multiply) variant 
%      [hi;lo]←x, out=hi, hi←(hi^(hi>>32))*a, hi←(hi^(hi>>48))*lo , x←x*a+c
% See RR_PCG for a convenient wrapper that takes care of state initialization. 
%
% INPUTS:       n = number of pseudorandom numbers to generate
%               c = increment for this stream
% INPUT/OUTPUT: x = one RR_uint128 state variable
% OUTPUT:       out = vector of n uint64 ouputs
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

a=(0xDA942042E4DD58B5);
for i=1:n
  hi=x.h; lo=x.l; hi=RR_prod64(bitxor(hi,bitsrl(hi,32)),a);
  out(i)=RR_prod64(bitxor(hi,bitsrl(hi,48)),lo); x=x*a+c;
end
