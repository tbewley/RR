% script <a href="matlab:Ztest">Ztest</a>
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 18.2.2.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 18</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.

disp('Compute the Z transform Y(z) of a signal whose Laplace transform is Y(s).')
close all; for i=1:3, figure(i); g.h=.1; g.T=10;
  switch i
    case 1, bs=[1],      as=[1 -.5]             % Exponentially unstable case
    case 2, bs=[1],      as=[1 0 1]             % Sinusoidal case
    case 3, bs=[1 -1 3], as=PolyPower([1 1],3)  % Multiple root case
  end
  g.styley='b-'; ResponseTF  (bs,as,0,g), hold on, [bz,az]=Z(bs,as,g.h)
  g.styley='r*'; ResponseTFdt(bz,az,0,g), hold off, disp(' ')
end
% end script Ztest