% script PlotMeshTest
% Test <a href="matlab:help StretchMesh">PlotMesh</a> by constructing an interesting 2D grid.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 8.1.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap08">Chapter 8</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also StretchMeshTest.  Depends on StretchMesh.

im=sqrt(-1); n=30; w=[0:1/(n-1):1];
x=StretchMesh(w,'h',0,1,1.75); y=StretchMesh(w,'p',0,1,1,2);
for i=1:n, for j=1:n, z(i,j)=x(i)+im*y(j); end, end, PlotMesh(z,1,n,n)

% end script PlotMeshTest