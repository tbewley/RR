% script RR_aliasing 
% A simple demonstration of the aliasing phenomenon.
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap08
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

clf; h=.1; om1=(9/8)*pi/h; om2=-(7/8)*pi/h;
t=[0:.001:1]; plot(t,sin(om1*t),'r-'); hold on; plot(t,sin(om2*t),'b--');
th=[0:h:1];   plot(th,sin(om1*th),'kx');
