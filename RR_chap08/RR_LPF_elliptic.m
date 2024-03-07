function F=RR_LPF_elliptic(n,epsilon,delta,omegac)
% function F=RR_LPF_elliptic(n,epsilon,delta,omegac)
% INPUTS:  n=order of filter, FOR n=2^s ONLY      [see, e.g., Figures 9.12b, 9.13b]
%          epsilon=ripple of gain in the passband [between 1/sqrt(1+epsilon^2) and 1]
%          delta  =ripple of gain in the stopband [between 0 and delta]
%          omegac =cutoff frequency of filter     [OPTIONAL, taken as 1 if omitted]
% OUTPUT:  F=n'th order elliptic low-pass filter of type RR_tf
% EXAMPLE: F=RR_LPF_elliptic(4,0.3,0.04,10), close all, RR_bode(F), figure(2), RR_bode_linear(F) 
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap08
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.
% Note: uses codes from the NR database https://github.com/tbewley/NR
% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

s=log2(n); z=0; p.n=n; p.target=1/(epsilon*delta); xi=RR_Bisection(1.0001,100,@Func,1e-6,0,p);
for r=s-1:-1:0, z=1./sqrt(1+sqrt(1-1./(CRF(2^r,xi,xi))^2)*(1-z)./(1+z)); z=[z; -z]; end
zeta=SN(n,xi,epsilon); a=-zeta*sqrt(1-zeta^2).*sqrt(1-z.^2).*sqrt(1-z.^2./xi^2);
b=z*sqrt(1-zeta^2*(1-1/xi^2)); c=1-zeta^2*(1-z.^2/xi^2); efz=i*xi./z; efp=(a+i*b)./c;
C=prod(efp)/prod(efz)/sqrt(1+epsilon^2); num=RR_poly(efz,C); den=RR_poly(efp,1);
if nargin>2, for k=1:n+1, num.poly(k)=num.poly(k)/omegac^(n-k-1);
                          den.poly(k)=den.poly(k)/omegac^(n-k-1); end, end
F=RR_tf(real(num.poly),real(den.poly));
disp(sprintf('Elliptic passband gain oscillation between %0.3g and 1.',1/sqrt(1+epsilon^2)))
disp(sprintf('Elliptic stopband gain oscillation between 0 and %0.3g.',delta))                     
end % function RR_LPF_elliptic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function zeta=SN(n,xi,epsilon)    % Computes the Jacobi elliptic function (for n=2^s only)
if n<4, t=sqrt(1-1/xi^2); zeta=2/((1+t)*sqrt(1+epsilon^2)+sqrt((1-t)^2+epsilon^2*(1+t)^2));
else,   zeta=SN(2,xi,sqrt(1/(SN(n/2,CRF(2,xi,xi),epsilon))^2 -1)); end  % Note: recursive.
end % function SN
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function R=CRF(n,xi,x)          % Compute the Chebyshev Rational Function (for n=2^s only)
if     n==1, R=x;                                    
elseif n==2, t=sqrt(1-1/xi^2); R=((t+1)*x^2-1)/((t-1)*x^2+1);
else,        R=CRF(n/2,CRF(2,xi,xi),CRF(2,xi,x));  end                  % Note: recursive.
end % function CRF
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function f=Func(xi,v,p) % Compute the discrimination factor L_n(xi) minus its target value.
f=CRF(p.n,xi,xi)-p.target;
end % function Func