function [s,c]=RR_sum8(x,y)
% function [s,c]=RR_sum8(x,y)
% INPUTS:  x, y are each uint8 (or single,double)
% OUTPUTS: s=x+y is uint8
%          c=carry bit (uint8, can ignore for wrap on uint9 overflow)
% TEST: x=uint8(147), y=uint8(3), [s,c]=RR_sum8(x,y)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

t=uint16(x)+uint16(y);  % Note: intermediate math is uint64
s=uint8(bitand(t,0xFFu16)); c=uint8(bitsra(t,8));