function Release                              
% This function estimates a contaminant release at time 0 based on 
% M measurements taken at time T.  Matlab code by T Bewley and F Alexander. 
% See Frank Alexander et al 2010, "Efficient reconstruction of contaminant release history"

% ---------- Initialize the simulation paramters (user input)  ----------
p.D=0.005; p.u=0.1; p.k=0.05; p.ceq=0.4; p.M=16; p.N=64; lambda=10; L=1; T=1; h=.001; alpha=0.005;
% --------------------------- end user input ---------------------------- 
p.dxN=L/p.N; p.xN=(0:p.N)*p.dxN;  p.dxM=L/p.M; p.xM=(1:p.M-1)*p.dxM; % grid
xMgrid=[1:p.M-1]*p.dxM; xNgrid=[0:p.N]*p.dxN;
figure(1); clf; hold on; title('concentration t=T (x=measurements, lines=estimates)');

% Notes:
% All arrays are indexed from 1, because braindead Matlab requires this.
% Some constants above are in a data structure named p, to ease passing them to subroutines

% Initialize concentrations 
c(1:p.N+1)=p.ceq;   

% Initialize measurements - these are kinda like yours Frank, but you probably want to replace them.
z=27*(xMgrid-.5)+.0001; y=.4+.1*sin(z)./z;
figure(1); plot(xMgrid,y,'x-'); 

for iteration=1:500;
  if (iteration<10), verbose=1; ls='r:'; elseif (mod(iteration,10)==0), verbose=1; ls='k-'; else, verbose=0; end;

  % March concentration forward in time.
  t=0; cs(1,:)=c; 
  for k=1:T/h
    k1=RHS_c(c,         p);
    k2=RHS_c(c+(h/2)*k1,p);
    k3=RHS_c(c+(h/2)*k2,p);
    k4=RHS_c(c+h*k3,    p);
    c=c+(h/6)*k1+(h/3)*(k2+k3)+(h/6)*k4; t=t+h;
    cs(k+1,:)=c;     % Save concentrations for use during backward march.
  end
if verbose==1; figure(1); plot(xNgrid,c,ls); end

  % March adjoint backward in time
  r(1:p.N+1)=0; kappa=p.N/p.M; r(kappa+1:kappa:(p.M-1)*kappa+1)=(c(kappa+1:kappa:(p.M-1)*kappa+1)-y);
  if verbose==1; figure(2); clf; plot(xNgrid,-r,'r--'); title('adjoint (dashed t=T, solid t=0'); hold on; end
  t=T;
  for k=T/h:-1:1
    k1=RHS_r(r,         cs(k+1,:),            p);
    k2=RHS_r(r+(h/2)*k1,(cs(k+1,:)+cs(k,:))/2,p);
    k3=RHS_r(r+(h/2)*k2,(cs(k+1,:)+cs(k,:))/2,p);
	k4=RHS_r(r+h*k3,    cs(k,:),              p);
    r=r+(h/6)*k1+(h/3)*(k2+k3)+(h/6)*k4; t=t-h;
  end
  if verbose==1; figure(2); plot(xNgrid,-r,'r-'); end

  % Update concentrations using fixed-coefficient steepest descent.
  % ok, steepest descent is really stupid.  but I think you are replacing this part anyway.
  g=r-lambda*[0, (r(3:p.N+1)-2*r(2:p.N)+r(1:p.N-1))/(p.dxN)^2, 0]; g(1)=g(2); g(p.N+1)=g(p.N);
  c=cs(1,:)-alpha*g; 
  if verbose==1; figure(3); clf; plot(xNgrid,c,'r-'); title('concentration t=0 (lines=estimates)'); pause(.01); end;

end % iteration loop
end % function Release.m

function k=RHS_c(c,p)                         
k(2:p.N)= p.D*(c(3:p.N+1)-2*c(2:p.N)+c(1:p.N-1))/(p.dxN)^2 ...
          -p.u*(c(3:p.N+1)-c(1:p.N-1))/(2*p.dxN)            ...
          -2*p.k*(c(2:p.N).^2 - p.ceq^2); k(1)=k(2); k(p.N+1)=k(p.N);
end % function RHS_c.m

function k=RHS_r(r,c,p)                         
k(2:p.N)= p.D*(r(3:p.N+1)-2*r(2:p.N)+r(1:p.N-1))/(p.dxN)^2 ...
		   +p.u*(r(3:p.N+1)-r(1:p.N-1))/(2*p.dxN)            ...
           -4*p.k*c(2:p.N).*r(2:p.N); k(1)=0; k(p.N+1)=0;
end % function RHS_r.m