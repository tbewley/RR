function OUT=RR_randi512
% function OUT=RR_randi512
% OUTPUT: generates a 512 bit random number of the RR_uint512 type
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

OUT=RR_uint512(RR_randi64,RR_randi64,RR_randi64,RR_randi64, ...
	           RR_randi64,RR_randi64,RR_randi64,RR_randi64);