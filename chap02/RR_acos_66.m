function [out]=RR_acos_66(x)
% function [out]=RR_acos_66(x)
% INPUT:  x, with -1<=x<=1
% OUTPUT: acos(x), with about 6.6 digits of precision
% TEST:   x=2*rand-1, a=acos(x), b=RR_acos_66(x), residual=norm(a-b)
% Renaissance Robotics codebase, Chapter 2, https://github.com/tbewley/RR
% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

if x==-1, out=pi; else, out=2*RR_atan_66(sqrt(1-x^2)/(1+x)); end
end