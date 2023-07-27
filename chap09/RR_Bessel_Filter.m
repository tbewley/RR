function F=RR_Bessel_Filter(n,omegac)
% function F=RR_Bessel_Filter(n,omegac)
% INPUTS:  n=order of filter
%          omegac=cutoff frequency of filter (OPTIONAL, taken as 1 if omitted)
% OUTPUT:  F=n'th order Bessel filter of type RR_tf
% EXAMPLE: F=RR_Bessel_Filter(4,0.1), close all, bode(F)
% Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License.

k=[n:-1:0]; den=RR_poly(factorial(2*n-k)./factorial(n-k)./factorial(k)./2.^(n-k));
if nargin>1, for k=1:n+1, den.poly(k)=den.poly(k)/omegac^(n-k-1); end, end
num=evaluate(den,0); F=RR_tf(num,den);