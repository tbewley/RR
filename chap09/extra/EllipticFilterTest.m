% script <a href="matlab:EllipticFilterTest">EllipticFilterTest</a>
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 17.5.3.2.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% See also ChebyshevFilterTest, InverseChebyshevFilterTest.  Depends on <a href="matlab:help Bode">Bode</a>, <a href="matlab:help PolyVal">PolyVal</a>.

clear all; close all; g.omega=logspace(-1,1,600); g.line=0;
figure(1); g.style='k-'; [num,den]=EllipticFilter(4,0.2,0.2); Bode(num,den,g);    
figure(2); semilogx(g.omega,abs(PolyVal(num,i*g.omega)./PolyVal(den,i*g.omega)).^2,g.style)
hold on;
figure(1); g.style='b-'; [num,den]=EllipticFilter(8,0.1,0.1); Bode(num,den,g);       
figure(2); semilogx(g.omega,abs(PolyVal(num,i*g.omega)./PolyVal(den,i*g.omega)).^2,g.style)

% end script EllipticFilterTest