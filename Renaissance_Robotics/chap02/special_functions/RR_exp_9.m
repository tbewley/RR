function [out]=RR_exp_9(x)
% function [out]=RR_exp_9(x)
% INPUT:  any real x
% OUTPUT: exp(x), with about 9 digits of precision (or better)
% TEST:   x=randn, a=exp(x), b=RR_exp_9(x), residual=norm(a-b)/norm(a)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

ln2=0.693147180559945; k=floor(0.5+x/ln2); r=x-k*ln2;
a=120+12*r^2; b=60*r+r^3; out=2^k*(a+b)/(a-b);