% script <a href="matlab:NR_CMGridTest">CMGridTest</a>
% Compute a conformal mapping from a Cartesian grid in the upper half-plane to the region
% above a unit step.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section B.6.2.2.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchapAB">Appendix B</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% See also OrthGridTest, SCGridTest.

clear; close all; g.x0=-9; g.x1=13; g.y1=3; II=131; JJ=31;
z=OrthGrid(II,JJ,'Cartesian',g,0,0,0,0); Plot2DMesh(z,1,II,JJ)
w=(sqrt(z-1).*sqrt(z+1)+acosh(z))/pi;    Plot2DMesh(w,2,II,JJ)
% end script NR_CMGridTest
