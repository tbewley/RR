function s=RR_sum32(a,b)
% function s=RR_sum32(a,b)
% Defines s=a+b with wrap on integer overflow, for {a,b}=uint32, using uint64 arithmetic
% TEST: a=intmax('uint32'), b=uint32(3), RR_sum32(a,b)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

s=uint32(bitand(uint64(a)+uint64(b),0xFFFFFFFFu64)); % drop the carry bit (wrap on overflow)
