function Wave2D(v)                                   % Numerical Renaissance Codebase 1.0
dt=0.0001; T=500;                                    % Simulation paramters
p.g=9.8; p.Nx=32; p.Ny=16; p.Lx=15; p.Ly=5;          % Shallow Water parameters.
p.dx=p.Lx/p.Nx; p.dy=p.Ly/p.Ny; p.Nxp=p.Nx+1; p.Nyp=p.Ny+1; p.dx2=2*p.dx; p.dy2=2*p.dy;
p.b=ones(p.Nxp,1); p.x=[0:p.dx:p.Lx]; p.y=[0:p.dy:p.Ly]; p.bb=p.b*ones(1,p.Nyp);
height=1.0; tightness=1.5;  for i=1:p.Nxp, for j=1:p.Nyp
  h(i,j)=1-height*exp(-tightness*((p.x(i)-p.Lx/3)^2+(p.y(j)-p.Ly/2)^2));
end, end
map=colormap('jet'); colormap(map(end:-1:1,:)); SimPlot_ShallowWater(h,0,0,0,dt,dt,v,p,0); pause(1);
for t=0:dt:T;
  for i=1:p.Nxp;
end % function Wave2D
