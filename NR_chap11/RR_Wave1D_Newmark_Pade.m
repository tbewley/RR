function [q,x]=RC_Wave1D_Newmark_Pade(L,Tmax,c,N,dt)
% function [q,x]=RC_Wave1D_Newmark_Pade(L,Tmax,c,N,dt)
% This script simulates the 1D Wave equation with periodic boundary conditions.
% Newmark's method is used in time with a fourth-order Pade method in space.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 11.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap11">Chapter 11</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_Wave1D_ItCN_FD, RC_Wave1D_Newmark_Pade.

dx=L/N; t=0; x=(-N/2:N/2-1)'*dx; q=exp(-x.^2/0.1); v=0; RC_PlotXY(x,q,t,-L/2,L/2,-0.2,1.2);
dt2=dt^2/2; beta=1/4; gamma=1/2; b1=1-2*beta; b2=2*beta; g1=1-gamma;
dd=-1.2*c^2/dx^2; ee=2.4*c^2/dx^2;  aa=.1+beta*dt^2*dd; bb=1+beta*dt^2*ee; 
a=RC_ThomasTT(0.1,1,.1,dd*q([N 1:N-1],1)+ee*q([1:N],1)+dd*q([2:N 1],1),N);
for n=1:Tmax/dt
  as=q+dt*v+dt2*b1*a;
  as=RC_ThomasTT(aa,bb,aa,-dd*as([N 1:N-1],1)-ee*as([1:N],1)-dd*as([2:N 1],1),N);
  q=q+dt*v+dt2*(b1*a+b2*as); v=v+dt*(g1*a+gamma*as); a=as;
  t=t+dt; RC_PlotXY(x,q,t,-L/2,L/2,-0.2,1.2);
end
end % function RC_Wave1D_Newmark_Pade
