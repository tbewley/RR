function RC_WaveFD                                     % Numerical Renaissance Codebase 1.0
% This script simulates the 1D Wave equation with periodic boundary conditions.
% CN timestepping is used with a FD method in space.
% ---------- Initialize the simulation paramters (user input)  ---------- 
L=6.28318531; Tmax=5000;  N=256;  dt=0.1;  TimeSteps=Tmax/dt;  PlotInterval=10;  dx=L/N;
t=0; cc=1.0; x=(-N/2:N/2-1)'*dx; u=exp(x.^2/0.25);  PlotXY(x,u,t,-L/2,L/2,-0.2,1.2);
% --------------------------- end user input ---------------------------- 
a(1:N,1)= -dt/(2*dx^2);    % precalculate coefficients used during march
b(1:N,1)=1+dt/dx^2;    
c(1:N,1)= -dt/(2*dx^2);  f=dt/(2*dx^2);
rhs=zeros(N,1); [rhs,a,b,c,d,e]=RC_Circulant(a,b,c,rhs,N); % Determine LU to reuse during march
for n=1:TimeSteps                                            % Leading-order cost:
  rhs(2:N,1)=phi(2:N)+e*(phi(3:N+1)-2*phi(2:N)+phi(1:N-1));  % ~ ?N
  t=t+dt;  rhs(1)=sin(t);                                    %
  u(1:N)=RC_CirculantLU(rhs,a,b,c,d,e,N);                       % ~ 9N
  PlotXY(x,u,t,-L/2,L/2,-0.2,1.2);
end                                                          % Total: ~ ?N per timestep
end % function RC_WaveFD.m