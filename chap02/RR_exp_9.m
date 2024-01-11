function [out]=RR_exp_9(x)
% function [out]=RR_exp_9(x)
% INPUT:  any real x
% OUTPUT: exp(x), with about 9 digits of precision (or better)
% TEST:   x=randn, a=exp(x), b=RR_exp_9(x), residual=norm(a-b)/norm(a)
%% Renaissance Robotics codebase, Chapter 2, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

ln2=0.693147180559945; 
k=floor(0.5+x/ln2); r=x-k*ln2; out=2^k*exp_9(r);
end
%%%%%%%%%%%%%%%%%
function [out]=exp_9(r) 
a=120+12*r^2; b=60*r+r^3; out=(a+b)/(a-b);
end