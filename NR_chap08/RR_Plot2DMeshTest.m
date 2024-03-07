% script <a href="matlab:RC_Plot2DMeshTest">RC_Plot2DMeshTest</a>
% Test <a href="matlab:help Plot2DMesh">RC_Plot2DMesh</a> by constructing an interesting 2D grid.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap08
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_Stretch1DMeshTest.  Depends on RC_Stretch1DMesh.

im=sqrt(-1); n=30; w=[0:1/(n-1):1];
x=RC_Stretch1DMesh(w,'h',0,1,1.75); y=RC_Stretch1DMesh(w,'p',0,1,1,2);
for i=1:n, for j=1:n, z(i,j)=x(i)+im*y(j); end, end, RC_Plot2DMesh(z,1,n,n)

% end script RC_Plot2DMeshTest
