% script <a href="matlab:Example_17_12">Example_17_12</a>
% Compute the step response of a discrete-time second-order system.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Exampe 17.12.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.

clear; close all; format compact;
syms p1 p2 b0
A=[p1 p2 1; -p1*(p2+1) -p2*(p1+1) -p2-p1; p1*p2 p2*p1 p2*p1]
b=[0; b0; 0]
c=A\b

g.styleu='r--'; g.styley='b*-'; h=1;
for theta=pi/10:pi/10:pi/5, figure
  for r=.7:.1:1
    a0=r^2; a1=-2*r*cos(theta); p1=(-a1+sqrt(a1^2-4*a0))/2; p2=(-a1-sqrt(a1^2-4*a0))/2;
    dc=-1; ds=(-a1-2)/sqrt(4*a0-a1^2);
    for k=0:60
      t(k+1)=k*h; u(k+1)=1;
      y(k+1)=r^k *(dc*cos(theta*k)+ds*sin(theta*k)) + 1;
    end
    plot(t,u,g.styleu,t,y,g.styley); hold on
  end
end

% end script Example_17_12

