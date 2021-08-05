function [num,den]=EllipticFilter(n,epsilon,delta)
% function [num,den]=EllipticFilter(n,epsilon,delta)
% Computes an n'th order elliptic filter (FOR n=2^s ONLY) with cutoff frequency omega_c=1, 
% ripple in the passband between 1/(1+epsilon^2) and 1, and
% ripple in the stopband between 0 and delta^2 (see Figures 17.20d, 17.21d).
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 17.5.3.2.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% Verify with <a href="matlab:help EllipticFilterTest">EllipticFilterTest</a>.  Depends on <a href="matlab:help Bisection">Bisection</a>, <a href="matlab:help Poly">Poly</a>, <a href="matlab:help Prod">Prod</a>.

s=log2(n); z=0; p.n=n; p.target=1/(epsilon*delta); xi=Bisection(1.0001,100,@Func,1e-6,0,p)
for r=s-1:-1:0, z=1./sqrt(1+sqrt(1-1./(CRF(2^r,xi,xi))^2)*(1-z)./(1+z)); z=[z; -z]; end
zeta=SN(n,xi,epsilon); a=-zeta*sqrt(1-zeta^2).*sqrt(1-z.^2).*sqrt(1-z.^2./xi^2);
b=z*sqrt(1-zeta^2*(1-1/xi^2)); c=1-zeta^2*(1-z.^2/xi^2); efz=i*xi./z; efp=(a+i*b)./c;
C=Prod(efp)/Prod(efz)/sqrt(1+epsilon^2); num=real(C*Poly(efz)); den=real(Poly(efp));
end % function EllipticFilter
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
