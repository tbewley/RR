function OUT=RR_randi128
% function OUT=RR_randi128
% OUTPUT: generates a 128 bit random number of the RR_uint128 type
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

OUT=RR_uint128(RR_randi64,RR_randi64);
