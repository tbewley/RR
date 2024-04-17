function [s,c]=RR_sum64(x,y)
% function [s,c]=RR_sum64(x,y)
% INPUTS:  x, y are each uint64 (or single,double)
% OUTPUTS: s=x+y is uint64
%          c=carry bit (uint64, can ignore for wrap on uint64 overflow)
% TEST: x=intmax('uint64'), y=3, [s,c]=RR_sum64(x,y)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

s=bitand(x,0x7FFFFFFFFFFFFFFF)+bitand(y,0x7FFFFFFFFFFFFFFF); % add the first 63 bits
MSB_sum=bitget(x,64)+bitget(y,64)+bitget(s,64);              % calculate the 64th bit
s=bitset(s,64,bitget(MSB_sum,1)); c=bitget(MSB_sum,2);  