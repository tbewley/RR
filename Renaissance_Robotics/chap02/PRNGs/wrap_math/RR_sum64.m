function s64=RR_sum64(a,b)
% function s64=RR_sum64(a,b)
% Defines a+b with wrap on integer overflow, for {a,b}=uint64, using uint64 arithmetic
% TEST: a=intmax('uint64'), b=uint64(3), RR_sum64(a,b)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

s64=bitand(a,0x7FFFFFFFFFFFFFFF)+bitand(b,0x7FFFFFFFFFFFFFFF); % add the first 63 bits
MSB_sum=bitget(a,64)+bitget(b,64)+bitget(s64,64); % calculate the 64th bit
s64=bitset(s64,64,bitget(MSB_sum,1));             % drop the carry bit (wrap on overflow)