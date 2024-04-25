function OUT=RR_randi64(NBITS)
% function OUT=RR_randi64(NBITS)
% INPUT:  NBITS = maximum number of bits of output integer (optional, default NBITS=64)
% OUTPUT: OUT  = a 64 bit random integer on [1,..,2^NBITS] of the RR_uint64 type
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin==1 & NBITS>63, NBITS=64, OUT=RR_randi64;
elseif nargin==0, OUT=RR_uint64(RR_xoshiro256pp);
else              OUT=RR_uint64(bitsrl(RR_xoshiro256pp,64-NBITS));  end