% script RR_Fig2_2.m
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear
for i=1:3; figure(i), clf, axis equal, axis([0 250 0 250]), hold on; m=251, c=0, x(1)=1,
  switch i, case 1, a=33, case 2, a=37, case 3, a=61, end
  for i=2:251, x(i)=mod(a*x(i-1)+c,m); plot(x(i-1),x(i),'kx'), pause(0.01), end
end
