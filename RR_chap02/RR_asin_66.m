function [out]=RR_asin_66(x)
% function [out]=RR_asin_66(x)
% INPUT:  x, with -1<=x<=1 
% OUTPUT: sin(x), with about 6.6 digits of precision
% TEST:   x=2*rand-1, a=asin(x), b=RR_asin_66(x), residual=norm(a-b)
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap02
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

out=2*RR_atan_66(x/(1+sqrt(1-x^2)));
end