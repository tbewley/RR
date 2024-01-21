% script RR_LorenzSim 
% A simple RK4 simulation of the Lorenz attractor.
%% Renaissance Robotics codebase, Chapter 7, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

clear; close all; global sig b rbar
sig=4; b=1; rbar=3*sig*(sig+b+3)/(sig-b-1);          % Define constants
T=100; h=0.01; k=1; x=5*randn(3,1)                   % Set up simulation
plot3(x(1),x(2),x(3),'kx'); view([-65 23]); hold on; % Set up plot
for t=0:h:T
   k1=RHS(x); k2=RHS(x+h*k1/2); k3=RHS(x+h*k2/2); k4=RHS(x+h*k3);
   xnew=x+h*(k1/6+k2/3+k3/3+k4/6);
   plot3([xnew(1) x(1)],[xnew(2) x(2)],[xnew(3) x(3)]);
   x=xnew; pause(0.001);
end
%%%%%%%%
function k=RHS(x)
global sig b rbar
   k=[sig*(x(2)-x(1)); -x(2)-x(1)*x(3); -b*x(3)+x(1)*x(2)-b*rbar];
end