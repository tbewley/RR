function [out]=RR_sin_73(x)
% function [out]=RR_sin_73(x)
% INPUT:  any real x
% OUTPUT: sin(x), with about 7.3 digits of precision
% TEST:   x=randn, a=sin(x), b=RR_sin_73(x), residual=norm(a-b)
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap02
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

out=RR_cos_73(x-pi/2);