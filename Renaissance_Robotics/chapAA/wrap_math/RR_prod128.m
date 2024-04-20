function [ph,pl,ch,cl]=RR_prod128(xh,xl,yh,yl)
% function [ph,pl,ch,cl]=RR_prod128(xh,xl,yh,yl)
% This code performs full uint128 by uint128 multiplication.
% INPUTS:  x={xh,xl}, y={xh,xl} where {xh,xl,yh,yl} are each uint64 (or single,double)
% OUTPUTS: {c,p}=x*y where c={ch,cl}, p={ph,pl}, and {ch,cl,ph,pl} are uint64
%          c=carry part where  and {ch,cl} are uint64 (ignore for wrap on uint128 overflow)
% TEST: xh=2, xl=intmax('uint64'), y=3, [ph,pl,c]=RR_prod128s(xh,xl,y)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

[ph,pl,cl]=RR_prod128s(xh,xl,yl)   % {cl ph pl} <- {xh xl} * yl   
[p1,p2,ch]=RR_prod128s(xh,xl,yh)   % {ch p1 p2} <- {xh xl} * yh 
[cl,ph,c1]=RR_sum128(cl,ph,p1,p2)  % {c1 cl ph} <- {cl ph} + {p1 p2}
ch=RR_sum64(ch,c1)                 %        ch  <- ch+c1

%             {xh xl}
%           * {yh yl}
% -------------------
%          {cl ph pl}
%     + {ch p1 p2}
% -------------------
%       {ch cl ph pl}
