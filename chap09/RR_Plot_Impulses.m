clear; close all; x=[-0.3:.0005:.3];
figure(1); subplot(1,3,1)
c{1}='r--'; c{2}='b-.'; c{3}='k-';
for res=1:3
  sigma=0.1/res^2;
  dsigma=exp(-x.^2/(2*sigma^2))/(sigma*sqrt(2*pi)); plot(x,dsigma,c{res}); hold on;
end

x=[0:.0005:.3];
for m=2:3
  subplot(1,3,m); plot([-0.3 0],[0 0]); hold on;
  for res=1:3
    lambda=20*res^2;
    dlamda=lambda^m*x.^(m-1).*exp(-lambda*x)/gamma(m); plot(x,dlamda,c{res});
  end
end
