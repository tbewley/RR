% script <a href="matlab:OrthGridTest">OrthGridTest</a>
% Test <a href="matlab:help OrthGrid">OrthGrid</a> by producing a few locally-orthognal grids with various stretching
% functions applied.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section B.6.2.1.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchapAB">Appendix B</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% See also CMGridTest, SCGridTest.

clear; II=30; JJ=30; figure(1); g.x0=0; g.x1=2; g.y1=1.5; 
for c0x=0:3; for c1x=0:3, for c0y=0:3; for c1y=0:3
  z=OrthGrid(II,JJ,'Cartesian',g,c0x,c1x,c0y,c1y);        clf, Plot2DMesh(z,1,II,JJ)
pause(0.1), end, end, end, end
for c0x=0:3; for c1x=0:3, for c0y=0:3; for c1y=0:3
  z=OrthGrid(II,JJ,'ConfocalParabola',g,c0x,c1x,c0y,c1y); clf, Plot2DMesh(z,1,II,JJ)
pause(0.1), end, end, end, end
for cx=0:3; for c0y=0:3, for c1y=0:3
  z=OrthGrid(II,JJ,'EllipseHyperbola',g,cx,cx,c0y,c1y);   clf, Plot2DMesh(z,1,II,JJ)
pause(0.1), end, end, end

% end script OrthGridTest
