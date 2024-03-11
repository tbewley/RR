function [out]=RR_ln_8(x)
% function [out]=RR_ln_8(x)
% INPUT:  any x>0
% OUTPUT: ln(x), with 8 digits of precision or better
% TEST:   x=(2*randn)^4, a=log(x), b=RR_ln_8(x), residual=norm(a-b)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

ln2=0.69314718055994531;
x_b=RR_float_to_bin(x); n=bin2dec(x_b(2:12))-1023; r=x/2^n;
y=(r-1)/(r+1); ys=y*y; num=2*y; sum=num;
% note: if speed is an issue, reduce the number of terms in the sum below
% for a faster, reduced precision approximation
for i=3:2:15; num=num*ys; sum=sum+num/i; end % (1 mult, 1 div, 1 add per step)
out=n*ln2+sum;