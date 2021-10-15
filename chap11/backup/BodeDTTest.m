% script <a href="matlab:BodeTest">BodeTest</a>
% Test <a href="matlab:help Bode">Bode</a> by plotting the Bode plot of 1st-order and 2nd-order systems.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 17.5.2.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.

figure(1); clf; g.omega=logspace(-1,1,200); g.line=0;
g.style='k-';  zeta=.01;  Bode([0 1],[1 1],g);       

% end script BodeTest