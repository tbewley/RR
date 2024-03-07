function [out]=RR_sin_32(x)
% function [out]=RR_sin_32(x)
% INPUT:  any real x
% OUTPUT: sin(x), with about 3.2 digits of precision
% TEST:   x=randn, a=sin(x), b=RR_sin_32(x), residual=norm(a-b)
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap02
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

out=RR_cos_32(x-pi/2);