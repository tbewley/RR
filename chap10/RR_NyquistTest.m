% script <a href="matlab:NyquistTest">NyquistTest</a>
% Illustrate the mapping of a Nyquist contour from the s-plane to the L plane for a few
% representative systems.
%% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

clear; close all; g.figs=1; g.figL=2; g.eps=.2; g.R=4;
num=15*[1 .3]; den=[1 12 20 0 0];           roots(den), Nyquist(num,den,g); pause
num=15*[1 .3]; den=Conv([1 12 20],[1 0 1]); roots(den), Nyquist(num,den,g); disp(' ')

% end script NyquistTest
