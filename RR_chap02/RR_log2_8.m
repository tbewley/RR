function [out]=RR_log2_8(x)
% function [out]=RR_log2_8(x)
% INPUT:  any x>0
% OUTPUT: log10(x), with 8 digits of precision or better
% TEST:   x=(2*randn)^4, a=log2(x), b=RR_log2_8(x), residual=norm(a-b)
%% Renaissance Robotics codebase, Chapter 2, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

ln2inv=1.44269504088896341; out=RR_ln_8(x)*ln2inv;