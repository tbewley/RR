function PlotLorenzRossler(xo,xn,to,tn,ho,hn,v)                         % PLOTTING ROUTINE 
% function PlotLorenzRossler(xo,xn,to,tn,ho,hn,v)
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.4.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

figure(1), plot3([xo(1) xn(1)],[xo(2) xn(2)],[xo(3) xn(3)]), title(sprintf('t=%d',tn))
axis equal, if v==2, figure(2), plot([to, tn],[ho hn]), hold on, end, pause(0.00001)
end % function PlotLorenzRossler
