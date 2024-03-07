function RC_Wire
% This script computes, plots, and animates the leading modes of vibration of a wire.
% ------------------ Initialize the simulation parameters (user input)  ------------------
clear;  alpha=1;  L=1;  n=256;  numplots=3;
% ----------------------------------- end user input -------------------------------------
DeltaX=L/n;  X=[0:DeltaX:L];                                % Set up grid and the A matrix
A=(alpha^2/DeltaX^2)*(diag(ones(n-2,1),-1) - 2*diag(ones(n-1,1),0) + diag(ones(n-2,1),1));
% solve eigenvalue problem for the natural modes of vibration, sort, and plot.
[V,D] = eig(A);  [V,D]=RC_EigSort(V,D);
omega_exact=[1:numplots]*pi*alpha/L,  n,  omega_numerical=sqrt(-D(1:numplots))
for i=1:numplots; figure(i);
  amp=1/max(abs(V(:,i))); plot(X,amp*[0 V(:,i)' 0],'*'); axis([0 1 -1 1]); hold on;
end
pause; figure(numplots+1); WireAnimate(D,V,X,n,DeltaX)
% end function RC_Wire.m
