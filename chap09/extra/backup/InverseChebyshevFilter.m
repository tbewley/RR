function [num,den]=InverseChebyshevFilter(n,delta)
% function [num,den]=InverseChebyshevFilter(n,delta)
% Computes an n'th order inverse Chebyshev filter with cutoff frequency omega_c=1 and 
% ripple in the stopband between 0 and delta^2 (see Figures 17.20c, 17.21c).
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 17.5.3.2.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help InverseChebyshevFilterTest">InverseChebyshevFilterTest</a>. Depends on <a href="matlab:help Poly">Poly</a>, <a href="matlab:help Prod">Prod</a>.

p=-i./cos(acos(i/delta)/n+[0:n-1]*pi/n); z=i./cos((2*[1:n]-1)*pi/(2*n));
C=Prod(p)/Prod(z); num=real(C*Poly(z)); den=real(Poly(p));
end % function InverseChebyshevFilter
