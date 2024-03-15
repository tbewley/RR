% script RR_equidistribution_clustering.m
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear, m=256, a(1)=157, a(2)=45, c(1)=47, c(2)=51
for j=1:2; figure(j), clf, axis equal, axis([0 256 0 256]), hold on
  x(1)=0; for i=2:256, x(i)=mod(a(j)*x(i-1)+c(j),m); plot(x(i-1),x(i),'kx'), end, x
end

figure(3), clf, axis equal, axis([0 256 0 256]), hold on
x=0; y=1; plot(x,y,'kx'), fprintf('i=')
for i=1:50, fprintf('%d ',i)
  for j=1:256, x=mod(a(1)*x+c(1),m); y=mod(a(2)*y+(1+(x==0))*c(2),m); plot(x,y,'kx'), end
  switch i
    case {1,2,3,4,5,6,7,20,50}, name=sprintf('k_dim_%d_256',i), print(name,'-depsc'), pause
  otherwise, pause(0.001); end
end