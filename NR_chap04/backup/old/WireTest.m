function RC_WireTest               
% function RC_WireTest
% This function computes, plots, and animates the leading modes of vibration of a wire.
% Uses RC_Eig.m from section 4.4.5, and RC_MergeSort.m from section 7.1.3, of RC.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

clear; close all; c=1; L=1; n=256; numplots=3;  % Initialize the simulation parameters 
DeltaX=L/n;  X=[0:DeltaX:L];                    % Set up grid and the A matrix
A=(c^2/DeltaX^2)*(diag(ones(n-2,1),-1) - 2*diag(ones(n-1,1),0) + diag(ones(n-2,1),1));
% Now solve the eigenvalue problem for the natural modes of vibration, sort, and plot. 
[lam,S]=RC_Eig(A);  [scratch,index]=RC_MergeSort(abs(lam)); S=S(:,index); lam=lam(index);
omega_exact=[1:numplots]*pi*c/L, n, omega_numerical=sqrt(-lam(1:numplots))'
for i=1:numplots; figure(i);
  amp=1/max(abs(S(:,i))); plot(X,amp*[0 S(:,i)' 0],'*'), axis([0 1 -1 1]), hold on
end
pause, figure(numplots+1), WireAnimate(lam,S,X,n,DeltaX)
end % function RC_WireTest
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function WireAnimate(Ds,Vs,X,n,DeltaX) 
% This is an auxiliary function built in to Wire.m, isolating the animation functionality. 
omega=sqrt(-Ds); maxframes=400; tmax=8; p=2; a=0.95/max(abs(Vs(:,p)));           
for t=0:tmax/maxframes:tmax             % First, animate a single mode.
  plot(X,a*[0 Vs(:,p)' 0]*sin(omega(p)*t),'Linewidth',2);
  axis([0 1 -1 1]); pause(0.01);
end; pause;
p=2; a=0.5/max(abs(Vs(:,p))); q=3; b=0.5/max(abs(Vs(:,q)));
for t=0:tmax/maxframes:tmax             % Then, animate a linear combination of two modes.
  plot(X,a*[0 Vs(:,p)' 0]*sin(omega(p)*t)+b*[0 Vs(:,q)' 0]*sin(omega(q)*t),'Linewidth',2);
  axis([0 1 -1 1]); pause(0.01);
end; pause; imax=round(n/3); fmax=0.95;              % Finally, animate a combination of
for i=0:imax;   c(i+1)=fmax*i/imax;         end      % modes which add up to an initially
for i=imax+1:n; c(i+1)=fmax*(n-i)/(n-imax); end      % plucked wire with zero velocity
for k=1:n-1                                          % and a triangular initial shape.
  f=[0 Vs(:,k)' 0]*[0 Vs(:,k)' 0]'*DeltaX;  chat(k)=(1/f)*([0 Vs(:,k)' 0]*c')*DeltaX;
end
for t=0:tmax/maxframes:tmax
  shape=0.; for k=1:n-1; shape=shape+chat(k)*[0 Vs(:,k)' 0]*cos(omega(k)*t); end 
  plot(X,shape,'Linewidth',2); axis([0 1 -1 1]); pause(0.01);
end;
end % function WireAnimate
