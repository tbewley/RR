% script <a href="matlab:RC_LagrangeTest">RC_LagrangeTest</a>
% Test <a href="matlab:help RC_Lagrange">RC_Lagrange</a> on data from a smooth (tanh) function.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

close all, clear, xmin=-5; xmax=5; xd=[xmin:1:xmax]; fd=tanh(xd);
x=[xmin:.01:xmax]; f=tanh(x); 
L=RC_Lagrange(x,xd,fd); plot(xd,fd,'k+',x,f,'k--',x,L,'k-')

% end script RC_LagrangeTest
