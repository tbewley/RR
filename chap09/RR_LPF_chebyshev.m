function F=RR_LPF_chebyshev(n,epsilon,omegac)
% function F=RR_LPF_chebyshev(n,epsilon,omegac)
% INPUTS:  n=order of filter (see, e.g., Figures 9.12b, 9.13b)
%          epsilon=ripple of gain in the passband [between 1/sqrt(1+epsilon^2) and 1]
%          omegac=cutoff frequency of filter [OPTIONAL, taken as 1 if omitted]
% OUTPUT:  F=n'th order Chebyshev low-pass filter of type RR_tf
% EXAMPLE: F=RR_LPF_chebyshev(4,0.3,10), close all, RR_bode(F), figure(2), RR_bode_linear(F)
% Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License.

if nargin<3, omegac=1; end 
p=i*cos(acos(i/epsilon)/n+[0:n-1]*pi/n); den=RR_poly(p,1);
for k=1:n+1, den.poly(k)=real(den.poly(k))/omegac^(n-k-1); end
num=omegac^2/(epsilon*2^(n-1)); F=RR_tf(num,den);
disp(sprintf('Chebyshev passband gain oscillation between %0.3g and 1.',1/sqrt(1+epsilon^2)))