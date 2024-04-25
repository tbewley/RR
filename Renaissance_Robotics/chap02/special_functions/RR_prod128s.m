function [ph,pl,c]=RR_prod128s(xh,xl,y)
% function [ph,pl,c]=RR_prod128s(xh,xl,y)
% INPUTS:  x={xh,xl}, y where {xh,xl,y} are each uint64 (or single,double)
% OUTPUTS: p=x*y where p={ph,pl}, and {ph,pl} are uint64
%          c=carry part (c is uint64, ignore for wrap on uint128 overflow)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

[pl,cl]=RR_prod64(xl,y);   % {cl pl} <-  xl * y 
[ph,ch]=RR_prod64(xh,y);   % {ch ph} <- xh * y 
[ph,cs]=RR_sum64(ph,cl);   % {cs ph} <- ph + cl
c=RR_sum64(ch,cs);         %      c  <- ch + cs

%         {xh xl}   This graphic summarizes how the above calculations are combined.
%       *     {y}
% ---------------
%         {cl pl}
%    + {ch ph}
% ---------------
%       {c ph pl}