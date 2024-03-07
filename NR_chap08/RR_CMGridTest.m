% script <a href="matlab:RC_CMGridTest">RC_CMGridTest</a>
% Compute a conformal mapping from a Cartesian grid in the upper half-plane to the region
% above a unit step.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap08
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_OrthGridTest, RC_SCGridTest.

clear; close all; g.x0=-9; g.x1=13; g.y1=3; II=131; JJ=31;
z=RC_OrthGrid(II,JJ,'Cartesian',g,0,0,0,0); RC_Plot2DMesh(z,1,II,JJ)
w=(sqrt(z-1).*sqrt(z+1)+acosh(z))/pi;    RC_Plot2DMesh(w,2,II,JJ)
% end script RC_CMGridTest
