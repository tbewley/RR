function [num,den]=ButterworthFilter(n)
% function [num,den]=ButterworthFilter(n)
% Computes the n'th order Butterworth filter with cutoff frequency omega_c=1.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 17.5.3.1.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help ButterworthFilterTest">ButterworthFilterTest</a>.  Depends on <a href="matlab:help Poly">Poly</a>.

p=exp(i*pi*(2*[1:n]-1+n)/(2*n)); num=1; den=Poly(p);
end % function ButterworthFilter