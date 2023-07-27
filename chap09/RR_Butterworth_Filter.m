function F=RR_Butterworth_Filter(n,omegac)
% function F=RR_Butterworth_Filter(n)
% INPUTS:  n=order of filter
%          omegac=cutoff frequency of filter (OPTIONAL, taken as 1 if omitted)
% OUTPUT:  F=n'th order Butterworth filter of type RR_tf
% EXAMPLE: F=RR_Butterworth_Filter(4,0.1), close all, bode(F)
% Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License.

p=exp(i*pi*(2*[1:n]-1+n)/(2*n)); num=RR_poly(1); den=RR_poly(p,1);
if nargin>1, for k=1:n+1, den.poly(k)=den.poly(k)/omegac^(n-k-1); end, end
F=RR_tf(num,den);