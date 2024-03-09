% script RR_Sim_Duffing
% A simple RK4 simulation of the Duffing oscillator.
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/RR_chap07
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear, close all, T=200; h=0.05; x=5*rand(2,1);              % Set up simulation
plot3(x(1),x(2),0,'kx'); view([-0.45 90]); hold on           % Set up plot
xlabel('x'), ylabel('xdot')
for t=0:h:T
   k1=RHS(x,t); k2=RHS(x+h*k1/2,t+h/2); k3=RHS(x+h*k2/2,t+h/2); k4=RHS(x+h*k3,t+h);
   xnew=x+h*(k1/6+k2/3+k3/3+k4/6);
   plot3([xnew(1) x(1)],[xnew(2) x(2)],[t-h,t]); axis([-4.5 4.5 -6 6 t-10 t])
   x=xnew; pause(0.001);
end
%%%%%%%%
function k=RHS(x,t) % Note: the "non-autonomous" Duffing RHS depends explicitly on t.
alpha=-1; beta=0.25; delta=0.1; gamma=2.5; omega=2;  % Define constants for Duffing
k=[x(2); -delta*x(2)-alpha*x(1)-beta*(x(1))^3-gamma*cos(omega*t)];
end
