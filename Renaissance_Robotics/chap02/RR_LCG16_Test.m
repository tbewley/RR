% RR_LCG16_Test
% Tests 3 very simply LCGs with m=2^8-5=251, and plots the adjacent pairs
% of the random numbers generated to detect k-tuple clustering.
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/RR_chap02
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear
m=251, a=33, x(1)=1, for i=2:255, x(i)=mod(a*x(i-1),m); end, x
figure(1), clf, hold on, for i=1:251, plot(x(i),x(i+1),'kx'), end
axis square, print -depsc ktuple_clusteringA.eps

m=251, a=37, x(1)=1, for i=2:255, x(i)=mod(a*x(i-1),m); end, x
figure(2), clf, hold on, for i=1:251, plot(x(i),x(i+1),'kx'), end
axis square, print -depsc ktuple_clusteringB.eps

m=251, a=61, x(1)=1, for i=2:255, x(i)=mod(a*x(i-1),m); end, x  % 61
figure(3), clf, hold on, for i=1:251, plot(x(i),x(i+1),'kx'), end
axis square, print -depsc ktuple_clusteringC.eps
