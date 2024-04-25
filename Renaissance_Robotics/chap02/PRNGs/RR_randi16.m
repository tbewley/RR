function OUT=RR_randi16(IMAX)
% function OUT=RR_randi16(IMAX)
% INPUT:  IMAX = maximum value of output integer (optional, default IMAX=65535)
% OUTPUT: OUT  = a 16 bit random integer on [1,..,IMAX] of the RR_uint16 type
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin==1 & IMAX>65535, IMAX=65535, OUT=RR_randi16;
elseif nargin==0, OUT=RR_uint16(bitsrl(RR_xoshiro128pp,16));
else              OUT=RR_uint16(RR_randi(IMAX));             end