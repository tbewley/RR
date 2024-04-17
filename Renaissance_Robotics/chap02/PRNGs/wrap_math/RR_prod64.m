function [p,c]=RR_prod64(x,y)
% function [p,c]=RR_prod64(x,y)
% INPUTS:  x, y are each uint64 (or uint32,single,double)
% OUTPUTS: p=x*y is uint64
%          c=carry part (uint64, can ignore for wrap on uint64 overflow)
% TEST: x=intmax('uint64'), y=3, [p,c]=RR_prod64(x,y)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

x=uint64(x); xh=bitsra(x,32); xl=bitand(x,0xFFFFFFFFu64); % {xh,xl}={hi,lo} 32 bits of x
y=uint64(y); yh=bitsra(y,32); yl=bitand(y,0xFFFFFFFFu64); % {yh,yl}={hi,lo} 32 bits of y
[pm,cm]=RR_sum64(xl*yh,xh*yl);
[p,c]  =RR_sum64(xl*yl,bitsll(pm,32));
c      =c+bitsll(cm,32)+bitsra(pm,32)+xh*yh;
