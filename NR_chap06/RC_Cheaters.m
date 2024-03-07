% Numarical solution of Problem 6.2 in RC.  By T Bewley
%%%%%%%%%%%%%%%%%%%%%%% problem setup %%%%%%%%%%%%%%%%%%%%%%%
clear; ybar=70; yvar=5; N=10000;  alphavec=[0.1 0.3 0.5];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
imax=length(alphavec);
for ii=1:imax; close all; disp(' '); alpha=alphavec(ii)
  x=min(100,ybar+sqrt(yvar)*randn);
  for k=2:N,  x(k)=alpha*x(k-1)+(1-alpha)*min(100,ybar+sqrt(yvar)*randn); end
  xbar=sum(x)/N, xbar_theory=ybar
  for j=-4:4, Rw(j+5)=sum((x(5+j:N-5+j)-xbar).*(x(5:N-5)-xbar))/(N-10+1); end
  varbar=Rw(5), varbar_theory=((1-alpha)/(1+alpha))*yvar
  fj=Rw/varbar, fj_theory=alpha.^abs([-4:4])
  plot([-4:4],fj,'b-',[-4:4],fj_theory,'r--');
  title(sprintf('alpha=%4.1f',alpha)); if ii<imax, pause; end
end
