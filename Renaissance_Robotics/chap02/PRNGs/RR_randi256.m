function OUT=RR_randi256(NBITS)
% function OUT=RR_randi256(NBITS)
% INPUT:  NBITS = maximum number of bits of output integer (optional, default NBITS=256)
% OUTPUT: OUT  = a 256 bit random integer on [1,..,2^NBITS] of the RR_uint256 type
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin==1 & NBITS>255, NBITS=256, OUT=RR_randi256;
else, OUT=RR_uint256(RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp);
	  if nargin==1, OUT=RR_bitsrl(OUT,256-NBITS);  end
end
