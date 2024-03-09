function F=RR_LPF_butterworth(n,omegac)
% function F=RR_LPF_butterworth(n,omegac)
% INPUTS:  n=order of filter
%          omegac=cutoff frequency of filter [OPTIONAL, taken as 1 if omitted]
% OUTPUT:  F=n'th order Butterworth filter of type RR_tf
% EXAMPLE: F=RR_LPF_butterworth(4,0.1), close all, RR_bode(F)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 8)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin<2, omegac=1; end 
p=exp(i*pi*(2*[1:n]-1+n)/(2*n)); den=RR_poly(p,1);
for k=1:n+1, den.poly(k)=real(den.poly(k))/omegac^(n-k-1); end
num=RR_evaluate(den,0); F=RR_tf(num,den);