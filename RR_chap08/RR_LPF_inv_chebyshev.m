function F=RR_LPF_inv_chebyshev(n,delta,omegac)
% function F=RR_LPF_inv_chebyshev(n,delta,omegac)
% INPUTS:  n=order of filter [see, e.g., Figures 9.12c, 9.13c]
%          delta =ripple of gain in the stopband [between 0 and delta]
%          omegac=cutoff frequency of filter     [OPTIONAL, taken as 1 if omitted]
% OUTPUT:  F=n'th order Inverse Chebyshev low-pass filter of type RR_tf
% EXAMPLE: F=RR_LPF_inv_chebyshev(4,0.04,0.1), close all, RR_bode(F), figure(2), RR_bode_linear(F)
%% Renaissance Robotics codebase, Chapter 8, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

if nargin<3, omegac=1; end 
p=-i./cos(acos(i/delta)/n+[0:n-1]*pi/n); z=i./cos((2*[1:n]-1)*pi/(2*n));
C=prod(p)/prod(z); num=RR_poly(z,C); den=RR_poly(p,1);
for k=1:n+1, num.poly(k)=num.poly(k)/omegac^(n-k-1);
             den.poly(k)=den.poly(k)/omegac^(n-k-1);
end, F=RR_tf(real(num.poly),real(den.poly));
disp(sprintf('Inverse Chebyshev stopband gain oscillation between 0 and %0.3g.',delta))