function OUT=RR_randi256
% function OUT=RR_randi256
% OUTPUT: generates a 256 bit random number of the RR_uint256 type
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

OUT=RR_uint256(RR_randi64,RR_randi64,RR_randi64,RR_randi64);