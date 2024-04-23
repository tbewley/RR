function [p,c]=RR_prod64s(x,y)
% function [p,c]=RR_prod64s(x,y)
% Note: this is a SIMPLIFIED version RR_prod64, ASSUMING y is zero in its upper 32 bits.
% INPUTS:  x, y are each uint64 (or uint32,single,double)
% OUTPUTS: p=x*y is uint64
%          c=carry part (uint64, can ignore for wrap on uint64 overflow)
% TEST: x=intmax('uint64'), y=3, [p,c]=RR_prod64(x,y)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

x=uint64(x); xh=bitsrl(x,32); xl=bitand(x,0xFFFFFFFFu64); % {xh,xl}={hi,lo} 32 bits of x
y=uint64(y); % ASSUMES (without checking) that y is zero in its upper 32 bits!
pm   =xh*y;
[p,c]=RR_sum64(xl*y,bitsll(pm,32));
c    =c+bitsra(pm,32);