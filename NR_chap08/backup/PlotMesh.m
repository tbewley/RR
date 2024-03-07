function PlotMesh(z,fig,II,JJ)
% function PlotMesh(z,fig,II,JJ)
% Plot a structured II by JJ mesh given by real and imaginary parts of z(1:II,1:JJ).
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 8.1.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap08">Chapter 8</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also StretchMesh.  Verify with: PlotMeshTest.

figure(fig); hold on; 
for i=1:II, plot(real(z(i,:)),imag(z(i,:)),'b-'); end
for j=1:JJ, plot(real(z(:,j)),imag(z(:,j)),'r-'); end, hold off; axis equal; axis off
end % function PlotMesh