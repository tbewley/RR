function [out]=RR_ln_8(x)
% function [out]=RR_ln_8(x)
% INPUT:  any x>0
% OUTPUT: ln(x), with 8 digits of precision (or better)
% TEST:   x=(2*randn)^4, a=log(x), b=RR_ln_8(x), residual=norm(a-b)
%% Renaissance Robotics codebase, Chapter 2, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

ln2=0.693147180559945;
x_b=RR_float_to_bin(x); n=bin2dec(x_b(2:12))-1023; r=x/2^n;
y=(r-1)/(r+1); sum=0; ypower=2/y; y2=y*y;
for i=1:2:13; ypower=ypower*y2; sum=sum+ypower/i; end
out=n*ln2+sum;