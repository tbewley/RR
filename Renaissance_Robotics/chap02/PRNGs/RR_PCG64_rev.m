function [out,x]=RR_PCG64_rev(n,x,c)
% function [out,x]=RR_PCG64_rev(n,x,c)
% PRNG using O'Neill's PCG64 scheme, DXSM variant, marched in reverse
%      x←astar*(x−c), [hi;lo]←x, hi←(hi^(hi>>32))*a, hi←(hi^(hi>>48))*lo, out=hi   
% See RR_PCG for a convenient wrapper that takes care of state initialization. 
% See https://www.pcg-random.org/download.html for O'Neill's C implementation.
%
% INPUTS:       n = number of pseudorandom numbers to generate
%               c = increment for this stream (RR_uint128)
% INPUT/OUTPUT: x = one RR_uint128 state variable
% OUTPUT:       out = vector of n uint64 ouputs
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

% debug this 

minus_c=-c; astar=RR_uint128(0x0CD365D2CB1A6A6C,0x8B838D0354EAD59D);
a=(0xDA942042E4DD58B5);
for i=1:n
  x=astar*(x+minus_c);       % Update state of LCG
  hi=x.h; lo=x.l; hi=RR_prod64(bitxor(hi,bitsrl(hi,32)),a);
  out(i)=RR_prod64(bitxor(hi,bitsrl(hi,48)),lo);
end


