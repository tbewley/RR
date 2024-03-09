function [h,T,y,p]=SimInit_ShallowWater(v)           % Numerical Renaissance Codebase 1.0  
h=0.0001; T=500;                                     % Simulation paramters
p.g=9.8; p.Nx=60; p.Ny=20; p.Lx=15; p.Ly=5;          % Shallow Water parameters.
p.dx=p.Lx/p.Nx; p.dy=p.Ly/p.Ny; p.Nxp=p.Nx+1; p.Nyp=p.Ny+1; p.dx2=2*p.dx; p.dy2=2*p.dy;
p.b=1.5-0.5*tanh([-5:(10/p.Nx):5]); p.x=[0:p.dx:p.Lx]; p.y=[0:p.dy:p.Ly];
p.bb=p.b'*ones(1,p.Nyp);
y(1:p.Nxp,1:p.Nyp,1:2)=0;      height=1.0; tightness=1.5;
for i=1:p.Nxp, for j=1:p.Nyp
  y(i,j,3)=p.b(i)-height*exp(-tightness*((p.x(i)-p.Lx/3)^2+(p.y(j)-p.Ly/2)^2));
end, end
map=colormap('jet'); colormap(map(end:-1:1,:)); SimPlot(y,y,0,0,h,h,v,p,0); pause(1);
end % function SimInit_ShallowWater.m
