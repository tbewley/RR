function [out]=RR_log10_8(x)
% function [out]=RR_log10_8(x)
% INPUT:  any x>0
% OUTPUT: log10(x), with 8 digits of precision (or better)
% TEST:   x=(2*randn)^4, a=log10(x), b=RR_log10_8(x), residual=norm(a-b)
% Renaissance Robotics codebase, Chapter 2, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License.

ln10=2.302585092994046;  out=RR_ln_8(x)/ln10;