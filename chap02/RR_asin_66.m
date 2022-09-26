function [out]=RR_asin_66(x)
% function [out]=RR_asin_66(x)
% INPUT:  x, with -1<=x<=1 
% OUTPUT: sin(x), with about 6.6 digits of precision
% TEST:   x=2*rand-1, a=asin(x), b=RR_asin_66(x), residual=norm(a-b)
% Renaissance Robotics codebase, Chapter 2, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under BSD 3-Clause License.

out=2*RR_atan_66(x/(1+sqrt(1-x^2)));
end