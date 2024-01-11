function [num,den]=ChebyshevFilter(n,epsilon)
% function [num,den]=ChebyshevFilter(n,epsilon)
% Computes an n'th order Chebyshev filter with cutoff frequency omega_c=1 and 
% ripple in the passband between 1/(1+epsilon^2) and 1 (see Figures 17.20b, 17.21b).
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 17.5.3.2.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help ChebyshevFilterTest">ChebyshevFilterTest</a>.

p=i*cos(acos(i/epsilon)/n+[0:n-1]*pi/n); num=1/(epsilon*2^(n-1)); den=real(Poly(p));
end % function ChebyshevFilter
