function Plot2DMesh(z,fig,II,JJ)
% function Plot2DMesh(z,fig,II,JJ)
% Plot a structured II by JJ mesh given by real and imaginary parts of z(1:II,1:JJ).
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap08
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also Stretch1DMesh.  Verify with: Plot2DMeshTest.

figure(fig); hold on; 
for i=1:II, plot(real(z(i,:)),imag(z(i,:)),'b-'); end
for j=1:JJ, plot(real(z(:,j)),imag(z(:,j)),'r-'); end, hold off; axis equal; axis off
end % function Plot2DMesh