% script <a href="matlab:BesselFilterTest">BesselFilterTest</a>
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 17.5.3.1.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% See also ButterworthFilterTest.  Depends on <a href="matlab:help Bode">Bode</a>.

figure(1); clf; g.omega=logspace(-1,2,200); g.line=0;
g.style='k-';  [num,den]=BesselFilter(1); Bode(num,den,g);       
g.style='b-';  [num,den]=BesselFilter(2); Bode(num,den,g);       
g.style='r-';  [num,den]=BesselFilter(3); Bode(num,den,g);       
g.style='k--'; [num,den]=BesselFilter(4); Bode(num,den,g);       
g.style='b--'; [num,den]=BesselFilter(5); Bode(num,den,g);       
g.style='r--'; [num,den]=BesselFilter(6); Bode(num,den,g);       

% end script BesselFilterTest