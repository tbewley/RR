function [sh,sl,c]=RR_sum128s(xh,xl,y)
% function [sh,sl]=RR_sum128s(xh,xl,y)
% INPUTS:  x={xh,xl}, y where {xh,xl,y} are each uint64
% OUTPUTS: s=x+y where s={sh,sl} and {sh,sl} are uint64
%          c=carry bit (uint64, can ignore for wrap on uint128 overflow)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

[sl,c]=RR_sum64(xl,y);  % {c sl} <- xl + y
[sh,c]=RR_sum64(xh,c);  % {c sh} <- sh + c

%     {xh xl}
%   +     yl   
% -----------
%   {c sh sl}