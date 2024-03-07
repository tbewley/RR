function [out]=RR_log10_8(x)
% function [out]=RR_log10_8(x)
% INPUT:  any x>0
% OUTPUT: log10(x), with 8 digits of precision or better
% TEST:   x=(2*randn)^4, a=log10(x), b=RR_log10_8(x), residual=norm(a-b)
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap02
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

ln10inv=0.43429448190325183; out=RR_ln_8(x)*ln10inv;