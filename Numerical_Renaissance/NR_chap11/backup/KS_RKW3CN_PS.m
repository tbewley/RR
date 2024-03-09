function KS_RKW3CN_PS                                % Numerical Renaissance Codebase 1.0
% This script simulates the Burgers equation or KS equation with periodic BCs.
% RKW3/CN timestepping is used (explicit on nonlinear terms, implicit on linear terms)
% with a pseudospectral method in space.
% ---------- Initialize the simulation paramters (user input)  ---------- 
L=200; Tmax=80; N=256; dt=0.1; PlotInt=10; alpha=1; % alpha=0 for Burgers, alpha=1 for KS
dx=L/N; x=(0:N-1)'*dx; u=sin(200*pi*x/L)+sin(340*pi*x/L)+.2*randn(N,1); uhat=RFFT(u,N);
% --------------------------- end user input ---------------------------- 
% Initialize coefficients used in computation
h_bar=dt*[8/15  2/15   1/3];  beta_bar=[1   25/8   9/4];  zeta_bar=[0  -17/8  -5/4];
kx=(2*pi/L)*[0:N/2-1]';  if alpha==0; Aop=-kx.^2; else Aop=kx.^2-kx.^4; end;
hb2=h_bar/2;  bbhb=beta_bar.*h_bar;  zbhb=zeta_bar.*h_bar;  Imhb2=1-h_bar/2;
kx(fix(N/3)+1:end)=0;  % This simple trick accomplishes dealiasing (see Section 5.16).
for k=1:Tmax/dt
  for rk=1:3 %%%%%%%%%%%%%%%%%%%%%%%% ALL 3 RK SUBSTEPS %%%%%%%%%%%%%%%%%%%%%%%%
    r=RFFTinv(uhat,N);  r=-r.*r;  rhat=i*kx.*RFFT(r,N);              % Leading-order cost:
    if (rk==1)                                                       % 2 FFTs per RK step
      uhat=(uhat+hb2(rk)*Aop.*uhat+bbhb(rk)*rhat)./(1-hb2(rk)*Aop);
	else
      uhat=(uhat+hb2(rk)*Aop.*uhat+bbhb(rk)*rhat+zbhb(rk)*rhat_old)./(1-hb2(rk)*Aop);
    end
    if (rk<3) rhat_old=rhat; end   % Save rhat for the next timestep
  end       %%%%%%%%%%%%%%%%%%%%%%%% END OF RK LOOP %%%%%%%%%%%%%%%%%%%%%%%%
  if (mod(k,PlotInt)==0) 
    pause(0.001); r=RFFTinv(uhat,N);  PlotXY(x,r,k*dt,0,L,-3,3);  axis([0 200 -1.5 1.5])
    figure(2); semilogy(kx(1:fix(N/3)),abs(uhat(1:fix(N/3))).^2); axis([0 3 1e-8 1e-1])
    figure(3); loglog(kx(1:fix(N/3)),abs(uhat(1:fix(N/3))).^2);   axis([3e-2 4 1e-8 1e-1])
  end
end                                         
end % function KS_RKW3CN_PS