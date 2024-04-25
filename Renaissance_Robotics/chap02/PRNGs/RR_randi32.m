function OUT=RR_randi32(NBITS)
% function OUT=RR_randi32(NBITS)
% INPUT:  NBITS = maximum number of bits of output integer (optional, default NBITS=32)
% OUTPUT: OUT  = a 32 bit random integer on [1,..,2^NBITS] of the RR_uint64 type
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin==1 & NBITS>31, NBITS=32, OUT=RR_randi32;
elseif nargin==0, OUT=RR_uint32(RR_xoshiro128pp);
else              OUT=RR_uint32(bitsrl(RR_xoshiro128pp,32-NBITS));  end