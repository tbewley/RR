% script RR_Fig9_01_plot_impulses
% This script just plots a few of impulses that, in the appropriate limits,
% form finite approximations of the Dirac Delta. 
% Numerical Renaissance codebase, Chapter 9, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

clear; close all; x=[-0.3:.00025:.3];
figure(1); subplot(1,3,1)
c{1}='r--'; c{2}='b-.'; c{3}='k-';
for res=1:3
  switch res
      case 1, sigma=0.1
      case 2, sigma=0.025
      case 3, sigma=0.01
  end
  dsigma=exp(-x.^2/(2*sigma^2))/(sigma*sqrt(2*pi)); plot(x,dsigma,c{res}); hold on;
  axis([-.25 .25 0 45])
end

x=[0:.0005:.3];
for m=2:3
  subplot(1,3,m); plot([-0.3 0],[0 0]); hold on;
  for res=1:3
  switch res
      case 1, lambda=20
      case 2, lambda=80
      case 3, lambda=200
  end
  dlamda=lambda^m*x.^(m-1).*exp(-lambda*x)/gamma(m); plot(x,dlamda,c{res});
  end
end
