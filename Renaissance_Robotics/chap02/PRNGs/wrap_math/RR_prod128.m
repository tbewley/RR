function [ph,pl]=RR_prod128(xh,xl,a)
% function [ph,pl]=RR_prod128(xh,xl,a)
% Computes p=x*a with wrap on integer overflow, for {xh,xl,a}=uint64 using uint64 arithmetic,
% where {xh,xl} and {ph,pl} are the high and low 64 bits of x and p, respectively.
% TEST: xh=0, xl=intmax('uint64'), a=uint64(3), [ph,pl]=RR_prod128(xh,xl,a)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

ah =bitsra(a,32);  al =bitand(a, 0xFFFFFFFFu64); % {ah, al} ={high,low} 32 bits of a
xhh=bitsra(xh,32); xhl=bitand(xh,0xFFFFFFFFu64); % {xhh,xhl}={high,low} 32 bits of xh
xlh=bitsra(xl,32); xll=bitand(xl,0xFFFFFFFFu64); % {xlh,xll}={high,low} 32 bits of xl

t=RR_sum64(al*xlh,ah*xll);
[pl,pc]=RR_sum64(al*xll,bitsll(t,32));
ph=RR_sum64(RR_sum64(RR_prod64(a,xh),pc),bitsra(t,32));
