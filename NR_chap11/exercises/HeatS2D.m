function HeatS2D                                     % Numerical Renaissance Codebase 1.0
% This function simulates the 2D heat equation on a bounded domain with periodic bcs,
% using CN in time and spectral differentiation in space.
Lx=5; Ly=5;  Tmax=10;  Nx=64; Ny=64;    dt=0.01;  TimeSteps=Tmax/dt;  dx=Lx/Nx;  dy=Ly/Ny;
t=0;  x=(0:Nx-1)'*dx;  y=(0:Ny-1)'*dy;  f(1:Nx,1:Ny)=0;  f(3*Nx/8:5*Nx/8,3*Ny/8:5*Ny/8)=1;
surf(x,y,f); pause(0.1); kx=(2*pi/Lx)*[0:Nx/2-1]'; ky=(2*pi/Ly)*[[0:Ny/2]';[-Ny/2+1:-1]'];
fhat= RFFT3D(f,Nx,Ny,1);
for TimeStep=1:TimeSteps
  for i=1:Nx/2; for j=1:Ny;
     fhat(i,j)=(1-dt*(kx(i)^2+ky(j)^2)/2)/(1+dt*(kx(i)^2+ky(j)^2)/2)*fhat(i,j);
  end; end;
  t=t+dt; surf(x,y,RFFT3Dinv(fhat,Nx,Ny,1)); title(sprintf('Time =%6.2f',t)); pause(0.01);
end
% end function HeatS2D.m
