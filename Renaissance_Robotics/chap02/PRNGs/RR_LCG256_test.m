% script RR_LCG256_test.m
% Script illustrating the behavior of simple PRNGs with LCGs of period m=2^8=256.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

clear, m=256, a(1)=157, c(1)=47, [g,e,astar]=RR_bezout(RR_int(m),RR_int(a));
astar=mod(int32(astar.v),int32(m)),  cstar=mod(c*(m-astar),m), pause

x(1)=0; for i=2:m+5, x(i)=mod(a*x(i-1)+c,m); end, x, dec2bin(x(1:9)), pause

x(1)=0; for i=2:m+5, x(i)=mod(astar*x(i-1)+cstar,m); end, x, pause

m=256, a=[157 45 181 125], c=[47 51 47 47],
for j=1:4; figure(j), clf, axis equal, axis([0 256 0 256]), hold on
  x(1)=0; for i =2:256, x(i)=mod(a(j)*x(i-1)+c(j),m); plot(x(i-1),x(i),'kx'), end
  % name=sprintf('ktuple_clustering%d',j), print('-vector',name,'-depsc'),
  pause
end, pause

figure(5), clf, axis equal, axis([0 256 0 256]), hold on
x=0; y=1; plot(x,y,'kx'), fprintf('i=')
for i=1:50, fprintf('%d ',i)
  for j=1:256, x=mod(a(1)*x+c(1),m); y=mod(a(2)*y+(1+(x==0))*c(2),m); plot(x,y,'kx'), end
  switch i
    case {1,2,3,4,5,6,7,20,50}
      % name=sprintf('k_dim_%02d_256',i), print('-vector',name,'-depsc')
      pause
  otherwise, pause(0.001); end
end
