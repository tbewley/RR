function RC_Wave1D_Newmark_Pade                         % Numerical Renaissance Codebase 1.0
% This script simulates the 1D Wave equation with periodic boundary conditions.
% Iterative CN timestepping is used with a Pade method in space.
% ------------------ Initialize the simulation paramters (user input)  -------------------
L=4; Tmax=4; N=128; dt=0.01; dx=L/N; IterSteps=3;
t=0; c=1.0; x=(-N/2:N/2-1)'*dx; q=exp(-x.^2/0.1); v=0;
% --------------------------------- end user input ---------------------------------------
PlotXY(x,q,t,-L/2,L/2,-0.2,1.2);  % initialize
dt2=dt^2/2; beta=1/4; gamma=1/2; b1=1-2*beta; b2=2*beta; g1=1-gamma;
dd=-1.2*c^2/dx^2; ee=2.4*c^2/dx^2;  aa=.1+beta*dt^2*dd; bb=1+beta*dt^2*ee; 
a=RC_ThomasTT(0.1,1,.1,dd*q([N 1:N-1],1)+ee*q([1:N],1)+dd*q([2:N 1],1),N);
for n=1:Tmax/dt
  as=q+dt*v+dt2*b1*a;
  as=RC_ThomasTT(aa,bb,aa,-dd*as([N 1:N-1],1)-ee*as([1:N],1)-dd*as([2:N 1],1),N);
  q=q+dt*v+dt2*(b1*a+b2*as); v=v+dt*(g1*a+gamma*as); a=as;
  t=t+dt; PlotXY(x,q,t,-L/2,L/2,-0.2,1.2);
end
end % function RC_Wave1D_Newmark_Pade