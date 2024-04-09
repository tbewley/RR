function [s,c]=RR_sum64(a,b)
% function [s,c]=RR_sum64(a,b)
% Defines s=a+b, with (optional) carry c, for {a,b}=uint64, using uint64 arithmetic
% note: can ignore the carry bit for wrap on integer overflow
% TEST: a=intmax('uint64'), b=uint64(3), [s,c]=RR_sum64(a,b)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

s=bitand(a,0x7FFFFFFFFFFFFFFF)+bitand(b,0x7FFFFFFFFFFFFFFF); % add the first 63 bits
MSB_sum=bitget(a,64)+bitget(b,64)+bitget(s,64);              % calculate the 64th bit
s=bitset(s,64,bitget(MSB_sum,1)); c=bitget(MSB_sum,2);  