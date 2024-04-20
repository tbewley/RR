function [ph,pl,c]=RR_prod128s(xh,xl,y)
% function [ph,pl,c]=RR_prod128s(xh,xl,y)
% Note: this is a SIMPLIFIED version RR_prod128, assuming y is zero in its upper 64 bits.
% INPUTS:  x={xh,xl}, y where {xh,xl,y} are each uint64 (or single,double)
% OUTPUTS: p=x*y where p={ph,pl} and {ph,pl} are uint64
%          c=carry part (c is uint64, ignore for wrap on uint128 overflow)
% TEST: xh=2, xl=intmax('uint64'), y=3, [ph,pl,c]=RR_prod128s(xh,xl,y)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

[pl,cl]=RR_prod64(xl,y); 
[ph,ch]=RR_prod64(xh,y);
[ph,cs]=RR_sum64(ph,cl);
c=RR_sum64(ch,cs);
