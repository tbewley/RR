% script <a href="matlab:Plot2DMeshTest">Plot2DMeshTest</a>
% Test <a href="matlab:help Plot2DMesh">Plot2DMesh</a> by constructing an interesting 2D grid.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 8.1.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap08">Chapter 8</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also Stretch1DMeshTest.  Depends on Stretch1DMesh.

im=sqrt(-1); n=30; w=[0:1/(n-1):1];
x=Stretch1DMesh(w,'h',0,1,1.75); y=Stretch1DMesh(w,'p',0,1,1,2);
for i=1:n, for j=1:n, z(i,j)=x(i)+im*y(j); end, end, Plot2DMesh(z,1,n,n)

% end script Plot2DMeshTest
