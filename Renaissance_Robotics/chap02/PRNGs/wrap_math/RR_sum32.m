function s32=RR_sum32(a,b)
% function s32=RR_sum32(a,b)
% Defines a+b with wrap on integer overflow, for {a,b}=uint32, using uint64 arithmetic
% TEST: a=intmax('uint32'), b=uint32(3), RR_sum32(a,b)
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

s32=uint32(bitand(uint64(a)+uint64(b),0xFFFFFFFFu64)); % drop the carry bit (wrap on overflow)
