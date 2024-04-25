function OUT=RR_randi512(NBITS)
% function OUT=RR_randi512(NBITS)
% INPUT:  NBITS = maximum number of bits of output integer (optional, default NBITS=512)
% OUTPUT: OUT  = a 512 bit random integer on [1,..,2^NBITS] of the RR_uint512 type
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin==1 & NBITS>511, NBITS=512, OUT=RR_randi512;
else, OUT=RR_uint512(RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp, ...
	                 RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp);
	  if nargin==1, OUT=RR_bitsrl(OUT,512-NBITS);  end
end
