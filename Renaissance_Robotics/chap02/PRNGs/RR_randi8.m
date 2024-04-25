function OUT=RR_randi8(IMAX)
% function OUT=RR_randi8(IMAX)
% INPUT:  IMAX = maximum value of output integer (optional, default IMAX=255)
% OUTPUT: OUT  = an 8 bit random integer on [1,..,IMAX] of the RR_uint8 type
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin==1 & IMAX>255, IMAX=255, OUT=RR_randi8;
elseif nargin==0, OUT=RR_uint8(bitsrl(RR_xoshiro128pp,24));
else              OUT=RR_uint8(RR_randi((IMAX)));          end