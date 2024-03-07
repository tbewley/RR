function RC_Diffusion1D_CN_FD
% function <a href="matlab:RC_Diffusion1D_CN_FD">RC_Diffusion1D_CN_FD</a>
% Simulate the 1D diffusion equation on 0<x<L with Dirichlet BCs
% using CN in time and 2nd-order central FD in space.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 11.2.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap11">Chapter 11</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear all;  L=5;  Tmax=10;  N=100;  dt=0.05;  TimeSteps=Tmax/dt;  dx=L/N;
t=0;  x=(0:N)'*dx;  phi=zeros(N+1,1);  RC_PlotXY(x,phi,t,0,L,-1,1); 
a(2:N,1)= -dt/(2*dx^2); a(1)=0;                     % Precalculate time-stepping coefficients
b(2:N,1)=1+dt/dx^2;     b(1)=1;                     % in order to minimize the flops needed
c(2:N,1)= -dt/(2*dx^2); c(1)=0;  e=dt/(2*dx^2);     % inside the time-marching loop.
rhs=zeros(N,1); [rhs,a,b,c]=RC_Thomas(a,b,c,rhs,N); % Determine L & U to reuse during march.
for n=1:TimeSteps                                           % Leading-order cost:
  rhs(2:N,1)=phi(2:N)+e*(phi(3:N+1)-2*phi(2:N)+phi(1:N-1));        % ~ 5N
  t=t+dt; rhs(1)=sin(t); phi(1:N)=RC_ThomasLU(a,b,c,rhs,N);           % ~ 5N
  RC_PlotXY(x,phi,t,0,L,-1,1);
end                                                         % Total: ~ 10N per timestep
end % function RC_Diffusion1D_CN_FD
