% script <a href="matlab:RR_Plot2DMeshTest">RR_Plot2DMeshTest</a>
% Test <a href="matlab:help Plot2DMesh">RR_Plot2DMesh</a> by constructing an interesting 2D grid.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap08
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 
% See also RR_Stretch1DMeshTest.  Depends on RR_Stretch1DMesh.

im=sqrt(-1); n=30; w=[0:1/(n-1):1];
x=RR_Stretch1DMesh(w,'h',0,1,1.75); y=RR_Stretch1DMesh(w,'p',0,1,1,2);
for i=1:n, for j=1:n, z(i,j)=x(i)+im*y(j); end, end, RR_Plot2DMesh(z,1,n,n)

% end script RR_Plot2DMeshTest
