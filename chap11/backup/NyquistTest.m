% script <a href="matlab:NyquistTest">NyquistTest</a>
% Illustrate the mapping of a Nyquist contour from the s-plane to the L plane for a few
% representative systems.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 18.1.3.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap18">Chapter 18</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.

clear; close all; g.figs=1; g.figL=2; g.eps=.2; g.R=4;
num=15*[1 .3]; den=[1 12 20 0 0];           roots(den), Nyquist(num,den,g); pause
num=15*[1 .3]; den=Conv([1 12 20],[1 0 1]); roots(den), Nyquist(num,den,g); disp(' ')

% end script NyquistTest
