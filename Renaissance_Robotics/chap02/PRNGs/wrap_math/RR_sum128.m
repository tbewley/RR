function [sh,sl]=RR_sum128(xh,xl,b)
% function [sh,sl]=RR_sum128(xh,xl,b)
% Defines s=x+b, for {xh,xl,b}=uint64, using uint64 arithmetic,
% where {xh,xl} and {sh,sl} are the high and low 64 bits of x and s, respectively.
% TEST: xh=3, xl=intmax('uint64'), b=intmax('uint64'), [sh,sl]=RR_sum128(xh,xl,b)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

[sl,c]=RR_sum64(xl,b); sh=RR_sum64(xh,c);