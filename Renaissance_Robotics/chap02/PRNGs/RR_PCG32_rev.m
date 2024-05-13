function [out,x]=RR_PCG32_rev(n,x,c)
% function [out,x]=RR_PCG32_rev(n,x,c)
% PRNG using O'Neill's PCG32 scheme, XSH RR variant, marched in reverse
%      x←astar*(x−c), t←((x>>18)^x)>>27, r←x>>59, z←(t>>r)|((t<<−r)&31)     
% See RR_PCG for a convenient wrapper that takes care of state initialization. 
% See https://www.pcg-random.org/download.html for O'Neill's C implementation.
%
% INPUTS:       n = number of pseudorandom numbers to generate
%               c = increment for this stream
% INPUT/OUTPUT: x = one uint64 state variable
% OUTPUT:       out = vector of n uint32 ouputs
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

minus_c=bitcmp(c)+0x1u64;
for i=1:n
  x=RR_prod64(0xC097EF87329E28A5,RR_sum64(x,minus_c));       % Update state of LCG
  temp   = uint32(bitand(bitsra(bitxor(bitsra(x,18),x),27),0xFFFFFFFFu64));
  rot    = uint32(bitsra(x,59));
  out(i) = bitor(bitsra(temp,rot),bitsll(temp,(bitand(bitcmp(rot)+1,31))));
end


