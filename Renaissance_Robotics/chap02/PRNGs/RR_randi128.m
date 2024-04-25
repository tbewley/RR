function OUT=RR_randi128(NBITS)
% function OUT=RR_randi128(NBITS)
% INPUT:  NBITS = maximum number of bits of output integer (optional, default NBITS=128)
% OUTPUT: OUT  = a 128 bit random integer on [1,..,2^NBITS] of the RR_uint128 type
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin==1 & NBITS>127, NBITS=128, OUT=RR_randi128;
else, OUT=RR_uint128(RR_xoshiro256pp,RR_xoshiro256pp);
	  if nargin==1, OUT=RR_bitsrl(OUT,128-NBITS);  end
end