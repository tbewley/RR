function RC_Burgers_KS_CRCKW3_PS
% function <a href="matlab:RC_Burgers_KS_CRCKW3_PS">RC_Burgers_KS_CRCKW3_PS</a>
% Simulate the 1D Burgers or KS equation on 0<x<L with periodic BCs using CN/RKW3 in time
% (explicit on nonlinear terms, implicit on linear terms) & pseudospectral in space.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 11.2.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap11">Chapter 11</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_Burgers_CRCKW3_FD and RC_Burgers_CRCKW3_FD_RS with FD implementations.

%%%%%%%%%%%%%%%%%%%% Initialize the simulation paramters (user input) %%%%%%%%%%%%%%%%%%%%
L=200; Tmax=80; N=256; dt=0.1; PlotInt=10; alpha=1; % alpha=0 for Burgers, alpha=1 for KS
dx=L/N; x=(0:N-1)'*dx; u=sin(200*pi*x/L)+sin(340*pi*x/L)+.2*randn(N,1); uhat=RFFT(u,N);
%%%%%%%%%%%% Precalculate the time-stepping coefficients used in the simulation %%%%%%%%%%
h_bar=dt*[8/15  2/15   1/3];  beta_bar=[1   25/8   9/4];  zeta_bar=[0  -17/8  -5/4];
kx=(2*pi/L)*[0:N/2-1]';  if alpha==0; Aop=-kx.^2; else Aop=kx.^2-kx.^4; end;
hb2=h_bar/2;  bbhb=beta_bar.*h_bar;  zbhb=zeta_bar.*h_bar;  Imhb2=1-h_bar/2;
kx(fix(N/3)+1:end)=0;  % This simple trick accomplishes dealiasing (see Section 5.7).
for k=1:Tmax/dt
  for rk=1:3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ALL 3 RK SUBSTEPS %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    r=RFFTinv(uhat,N);  r=-r.*r;  rhat=i*kx.*RFFT(r,N);              % Leading-order cost:
    if (rk==1)                                                       % 2 FFTs per RK step
      uhat=(uhat+hb2(rk)*Aop.*uhat+bbhb(rk)*rhat)./(1-hb2(rk)*Aop);
	else
      uhat=(uhat+hb2(rk)*Aop.*uhat+bbhb(rk)*rhat+zbhb(rk)*rhat_old)./(1-hb2(rk)*Aop);
    end
    if (rk<3) rhat_old=rhat; end   % Save rhat for the next timestep
  end %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END OF RK LOOP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  if (mod(k,PlotInt)==0) 
    pause(0.001); r=RFFTinv(uhat,N);  PlotXY(x,r,k*dt,0,L,-3,3);  axis([0 200 -1.5 1.5])
    figure(2); semilogy(kx(1:fix(N/3)),abs(uhat(1:fix(N/3))).^2); axis([0 3 1e-8 1e-1])
    figure(3); loglog(kx(1:fix(N/3)),abs(uhat(1:fix(N/3))).^2);   axis([3e-2 4 1e-8 1e-1])
  end
end                                         
end % function RC_Burgers_KS_CRCKW3_PS
