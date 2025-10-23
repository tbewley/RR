function [areaR,areaB]=RR_sphere_tri_grid_characterize(x,xR,xB,N,orthant)
for i=1:N, for j=1:N+1-i
  a=norm(x(:,i,j)-x(:,i+1,j)); b=norm(x(:,i,j)-x(:,i,j+1)); c=norm(x(:,i+1,j)-x(:,i,j+1));
  s=(a+b+c)/2; areaR(i,j)=sqrt(s*(s-a)*(s-b)*(s-c));  % Heron's formula for area of R cells
end, end
for i=2:N, for j=1:N+1-i
  a=norm(x(:,i,j)-x(:,i-1,j+1)); b=norm(x(:,i,j)-x(:,i,j+1)); c=norm(x(:,i-1,j+1)-x(:,i,j+1));
  s=(a+b+c)/2; areaB(i,j)=sqrt(s*(s-a)*(s-b)*(s-c));  % Heron's formula for area of B cells
end, end