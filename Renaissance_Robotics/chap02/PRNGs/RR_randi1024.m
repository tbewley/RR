function OUT=RR_randi1024(NBITS)
% function OUT=RR_randi1024(NBITS)
% INPUT:  NBITS = maximum number of bits of output integer (optional, default NBITS=1024)
% OUTPUT: OUT  = a 1024 bit random integer on [1,..,2^NBITS] of the RR_uint1024 type
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin==1 & NBITS>1023, NBITS=1024, OUT=RR_randi1024;
else, OUT=RR_uint1024(RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp, ...
	                  RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp, ...
	                  RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp, ...
	                  RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp,RR_xoshiro256pp);
	  if nargin==1, OUT=RR_bitsrl(OUT,1024-NBITS);  end
end
