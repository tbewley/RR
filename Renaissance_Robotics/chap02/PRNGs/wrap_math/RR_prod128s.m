function [ph,pl]=RR_prod128s(x,a)
% function [ph,pl]=RR_prod128s(x,a)
% Computes p=x*a with wrap on integer overflow, for {x,a}=uint64 using uint64 arithmetic,
% where {ph,pl} are the high and low 64 bits of p, respectively.
% TEST: x=intmax('uint64'), a=uint64(3), [ph,pl]=RR_prod128s(x,a)
% Note: this is a SIMPLIFIED version RR_prod128, assuming xh is zero.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

ah=bitsra(a,32); al=bitand(a,0xFFFFFFFFu64); % {ah,al}={high,low} 32 bits of a
xh=bitsra(x,32); xl=bitand(x,0xFFFFFFFFu64); % {xh,xl}={high,low} 32 bits of x

t=RR_sum64(al*xh,ah*xl);
[pl,pc]=RR_sum64(al*xl,bitsll(t,32));
ph=RR_sum64(pc,bitsra(t,32));
