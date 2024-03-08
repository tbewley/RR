% script <a href="matlab:RR_CMGridTest">RR_CMGridTest</a>
% Compute a conformal mapping from a Cartesian grid in the upper half-plane to the region
% above a unit step.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap08
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 
% See also RR_OrthGridTest, RR_SCGridTest.

clear; close all; g.x0=-9; g.x1=13; g.y1=3; II=131; JJ=31;
z=RR_OrthGrid(II,JJ,'Cartesian',g,0,0,0,0); RR_Plot2DMesh(z,1,II,JJ)
w=(sqrt(z-1).*sqrt(z+1)+acosh(z))/pi;    RR_Plot2DMesh(w,2,II,JJ)
% end script RR_CMGridTest
