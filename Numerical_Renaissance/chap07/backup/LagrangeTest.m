% script <a href="matlab:RR_LagrangeTest">RR_LagrangeTest</a>
% Test <a href="matlab:help RR_Lagrange">RR_Lagrange</a> on data from a smooth (tanh) function.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 

close all, clear, xmin=-5; xmax=5; xd=[xmin:1:xmax]; fd=tanh(xd);
x=[xmin:.01:xmax]; f=tanh(x); 
L=RR_Lagrange(x,xd,fd); plot(xd,fd,'k+',x,f,'k--',x,L,'k-')

% end script RR_LagrangeTest
