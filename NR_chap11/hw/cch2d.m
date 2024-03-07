function cch2d
% This Matlab code simulates the 2D Convective Cahn-Hilliard equation
% using RK3/CN timestepping and spectral differentiation in space on
% a square periodic domain.
% Written by Thomas R. Bewley on May 24, 2003.

clear all;  global N2 L; 

% ---------- Initialize the simulation paramters (user input)  ----------
N2= 32;  
L = 30; 
D = 10;       % Note that D -> infty recovers KS.
dt = 0.01;    % Note: if the simulation blows up, use a smaller timestep!
TimeSteps = 200000;
PlotInterval = 50;
Alpha = 0;  Beta = 0;  % Anisotropy coefficients
% --------------------------- end user input ---------------------------- 

% Initialize the grid and other variables.
global N N2 Nh x y kx ky; 
N=round(2*N2/3);   Nh=round(N/2);   dx=L/N2;  dy=dx;
for j=1:N2
   for k=1:N2
     x(j,k) = (j-1) * dx - L/2; 
     y(j,k) = (k-1) * dy - L/2;
   end
end
for j=1:Nh
   for k=1:2*Nh-1
     kx(j,k)  = 2*pi*(j-1)/L; 
     ky(j,k)  = 2*pi*(k-Nh)/L;
   end
end
kx2=kx.^2;  ky2=ky.^2;  k2=kx2+ky2;  kxy=kx.*ky;  k4=k2.^2; k2mk4=k2-k4;
D2inv=1.0/D^2;

% Initialize the state
hr=0.1*(2*rand(N2,N2)-1);
hf=Transform2Fourier(hr);
PlotFlow(hf,0);

% Initialize the RK3 coefficients
beta  = [4.0/15.0   1.0/15.0    1.0/6.0];
gamma = [8.0/15.0   5.0/12.0    3.0/4.0];
zeta  = [0.0       -17.0/60.0  -5.0/12.0];

% Now simulate the system.
for TimeStep=1:TimeSteps
  for rk=1:3

     % Compute Af.
     hr=Transform2Real(hf);
     hxr=Transform2Real(i*kx.*hf);
     hyr=Transform2Real(i*ky.*hf);
     Ar=Beta*hxr.*hyr.*Transform2Real(-kxy.*hf);
     hxr=hxr.^2;   hyr=hyr.^2;
     Af=Transform2Fourier(0.5*(hxr+hyr)+D2inv*( ...
        3*((hxr+Alpha*hyr).*Transform2Real(-kx2.*hf) + ...
           (hyr+Alpha*hxr).*Transform2Real(-ky2.*hf)) + Ar));

     % Compute Rf (store it in Af).
     if (rk<3) Af_old=Af; end
     Af=(1+(beta(rk)*dt)*k2mk4).*hf + (gamma(rk)*dt)*Af;
     if (rk>1) Af=Af+(zeta(rk)*dt)*Af_old; end

     % Solve for hf.
     hf=Af./(1-(beta(rk)*dt)*k2mk4);

  end % End of rk loop

  if (mod(TimeStep,PlotInterval)==0) PlotFlow(hf,TimeStep*dt); end

end % End of simulation

return; % End of main program.

function [vr] = Transform2Real (vf);
global N N2 Nh;
vt(1:N2,       1:N2)       = 0.0;
vt(1:Nh,       1:Nh)       =      vf(1:Nh,Nh:2*Nh-1);
vt(1:Nh,       N2-Nh+2:N2) =      vf(1:Nh,1:Nh-1);
vt(N2+2-(2:Nh),1)          = conj(vf(2:Nh,Nh));
vt(N2+2-(2:Nh),2:Nh)       = conj(vf(2:Nh,Nh-1:-1:1));
vt(N2+2-(2:Nh),N2-Nh+2:N2) = conj(vf(2:Nh,2*Nh-1:-1:Nh+1));
vr = real(ifft2(vt));
return;

function [vf] = Transform2Fourier (vr);
global N N2 Nh;
vt = fft2(vr);
vf(1:Nh,Nh:2*Nh-1) = vt(1:Nh,1:Nh);
vf(1:Nh,1:Nh-1)    = vt(1:Nh,N2-Nh+2:N2);
return;

function PlotFlow(vf,t)
global x y kx ky L N2; 
figure(1); clf; eps=0.001;  
vr=Transform2Real(vf);
ma=max(max(max(vr)));
mi=min(min(min(vr)));
vr=(vr-mi+eps)/(ma-mi+eps);
surf(x,y,vr); view(-20,75);  
title(sprintf('Time = %5.2f, Max = %5.2f, Min = %5.2f',t,ma,mi));
pause(0.001);
return;
