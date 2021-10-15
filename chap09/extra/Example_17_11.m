% script <a href="matlab:Example_17_11">Example_17_11</a>
% Compute the step response of a continuous-time second-order system.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Exampe 17.11.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.

clear; close all; format compact;
syms p1 p2
A=[1 1 1; p1 p2 p1+p2;0 0 1]
b=[0; 0; 1/(p1*p2)]
c=A\b

g.styleu='r--'; g.styley='b-'; h=.01; Tmax=10; t=[0:h:Tmax];
for omegan=1:3:4, figure
  for zeta=0:.1:1
    dc=-1; ds=-zeta/sqrt(1-zeta^2); omegad=omegan*sqrt(1-zeta^2); sigma=zeta*omegan;
    u=1*ones(size(t)); y=exp(-sigma*t).*(dc*cos(omegad*t)+ds*sin(omegad*t))+1;
    plot(t,u,g.styleu,t,y,g.styley); hold on
  end
end

% end script Example_17_11

