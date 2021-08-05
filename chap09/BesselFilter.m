function [num,den]=BesselFilter(n)
% function [num,den]=BesselFilter(n)
% Computes the n'th order Bessel filter with cutoff frequency omega_c=1.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 17.5.3.1.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help ButterworthFilterTest">ButterworthFilterTest</a>.

k=[n:-1:0]; den=Fac(2*n-k)./Fac(n-k)./Fac(k)./2.^(n-k); num=PolyVal(den,0);
end % function BesselFilter