% Numerical Renaissance codebase, Appendix B, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

clear; close all; R=[0:.1:1.5]; ii=i;
theta=[-180:10:1.5*360]*pi/180;
for i=1:length(R), for j=1:length(theta)
   x(i,j)=R(i)*sin(theta(j)); 
   y(i,j)=R(i)*cos(theta(j)); 
   f(i,j)=sqrt(R(i))*sin(theta(j)/2); 
   c(i,j)=theta(j)/2;
end; end
figure(1); colormap(hsv(128)); surf(x,y,f,c), axis tight; view(-112,12);
print -depsc RiemannSqrt.eps

R=[0.001:.1:1.501]; theta=[0:10:3*360]*pi/180;
for i=1:length(R), for j=1:length(theta)
   x(i,j)=R(i)*sin(theta(j)); 
   y(i,j)=R(i)*cos(theta(j)); 
   f(i,j)=abs(log(R(i))+ii*theta(j));
   c(i,j)=theta(j);
end; end
figure(2); colormap(jet(128)); surf(x,y,f,c); h=gca;
set(gca,'ztick',[]); axis tight; view(-112,18);
print -depsc RiemannLog.eps
