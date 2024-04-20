function [p,c]=RR_prod8(x,y)
% function [p,c]=RR_prod8(x,y)
% INPUTS:  x, y are each uint8 (or single,double)
% OUTPUTS: p=x*y is uint8
%          c=carry part (uint8, can ignore for wrap on uint8 overflow)
% TEST: x=uint8(147), y=uint8(3), [s,c]=RR_sum8(x,y)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

t=uint16(x)*uint16(y);  % Note: intermediate math is uint16
p=uint8(bitand(t,0xFFu16)); c=uint8(bitsra(t,8));
