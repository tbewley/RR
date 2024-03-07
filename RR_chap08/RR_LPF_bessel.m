function F=RR_LPF_bessel(n,omegac)
% function F=RR_LPF_bessel(n,omegac)
% INPUTS:  n=order of filter                 [OPTIONAL, taken as 4 if omitted]
%          omegac=cutoff frequency of filter [OPTIONAL, taken as 1 if omitted]
% OUTPUT:  F=n'th order Bessel filter of type RR_tf
% TEST:    F=RR_LPF_bessel(4,0.1), close all, RR_bode(F)
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap08
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

if nargin<2, omegac=1; end, if nargin<1, n=4; end
k=[n:-1:0]; den=RR_poly(factorial(2*n-k)./factorial(n-k)./factorial(k)./2.^(n-k));
for k=1:n+1, den.poly(k)=den.poly(k)/omegac^(n-k-1); end
num=RR_evaluate(den,0); F=RR_tf(num,den);