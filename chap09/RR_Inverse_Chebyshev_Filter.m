function [num,den]=RR_Inverse_Chebyshev_Filter(n,delta)
% function [num,den]=RR_Inverse_Chebyshev_Filter(n,delta)
% Computes an n'th order inverse Chebyshev filter with cutoff frequency omega_c=1 and 
% ripple in the stopband between 0 and delta^2 (see Figures 17.20c, 17.21c).
% Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under BSD 3-Clause License.
% Verify with: <a href="matlab:help InverseChebyshevFilterTest">InverseChebyshevFilterTest</a>. Depends on <a href="matlab:help Poly">Poly</a>, <a href="matlab:help Prod">Prod</a>.

p=-i./cos(acos(i/delta)/n+[0:n-1]*pi/n); z=i./cos((2*[1:n]-1)*pi/(2*n));
C=Prod(p)/Prod(z); num=real(C*Poly(z)); den=real(Poly(p));