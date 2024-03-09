% script RR_Sim_Rossler
% A simple RK4 simulation of the Rossler attractor.
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap07
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear, close all, T=100; h=0.04; x=[10*randn; 10*randn; 0];  % Set up simulation
plot3(x(1),x(2),x(3),'kx'); view([-65 23]); hold on          % Set up plot
xlabel('x'), ylabel('y'), zlabel('z')
for t=0:h:T
   k1=RHS(x); k2=RHS(x+h*k1/2); k3=RHS(x+h*k2/2); k4=RHS(x+h*k3);
   xnew=x+h*(k1/6+k2/3+k3/3+k4/6);
   plot3([xnew(1) x(1)],[xnew(2) x(2)],[xnew(3) x(3)]);
   x=xnew; pause(0.001);
end
%%%%%%%%
function k=RHS(x)     
a=0.1; b=0.1; c=14;      % Define constants
k=[-x(2)-x(3); x(1)+a*x(2); b+x(3)*(x(1)-c)];
end