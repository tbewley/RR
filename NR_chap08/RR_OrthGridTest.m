% script <a href="matlab:RC_OrthGridTest">OrthGridTest</a>
% Test <a href="matlab:help RC_OrthGrid">RC_OrthGrid</a> by producing a few locally-orthognal grids with various stretching
% functions applied.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap08
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_CMGridTest, RC_SCGridTest.

clear; II=30; JJ=30; figure(1); g.x0=0; g.x1=2; g.y1=1.5; 
for c0x=0:3; for c1x=0:3, for c0y=0:3; for c1y=0:3
  z=RC_OrthGrid(II,JJ,'Cartesian',g,c0x,c1x,c0y,c1y);        clf, RC_Plot2DMesh(z,1,II,JJ)
pause(0.1), end, end, end, end
for c0x=0:3; for c1x=0:3, for c0y=0:3; for c1y=0:3
  z=RC_OrthGrid(II,JJ,'ConfocalParabola',g,c0x,c1x,c0y,c1y); clf, RC_Plot2DMesh(z,1,II,JJ)
pause(0.1), end, end, end, end
for cx=0:3; for c0y=0:3, for c1y=0:3
  z=RC_OrthGrid(II,JJ,'EllipseHyperbola',g,cx,cx,c0y,c1y);   clf, RC_Plot2DMesh(z,1,II,JJ)
pause(0.1), end, end, end

% end script RC_OrthGridTest
