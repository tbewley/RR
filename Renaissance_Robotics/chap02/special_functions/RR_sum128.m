function [sh,sl,c]=RR_sum128(xh,xl,yh,yl)
% function [sh,sl]=RR_sum128(xh,xl,yh,yl)
% INPUTS:  x={xh,xl}, y={yh,yl} where {xh,xl,yh,yl} are each uint64
% OUTPUTS: s=x+y where s={sh,sl} and {sh,sl} are uint64
%          c=carry bit (uint64, can ignore for wrap on uint128 overflow)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

[sh,sl,c1]=RR_sum128s(xh,xl,yl); % {c1 sh pl} <- {xh xl} + yl
[sh,c2]=RR_sum64(sh,yh);         %    {c2 sh} <-     sh  + yh
c=c1+c2;                         %         c  <-     c1  + c2

%          {xh xl}
%        + {yh yl}   
% ----------------
%        {c sh sl}