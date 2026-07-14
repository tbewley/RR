function [areaR,Erms,Fmin]=RR_sphere_tri_grid_characterize(x,N)
for i=1:N, for j=1:N+1-i
  e1=norm(x(:,i,j)-x(:,i+1,j));
  e2=norm(x(:,i,j)-x(:,i,j+1));
  e3=norm(x(:,i+1,j)-x(:,i,j+1));
  s=(e1+e2+e3)/2; area(i,j)=sqrt(s*(s-e1)*(s-e2)*(s-e3)); % Herod's formula for area of R cells
  theta_a=acosd((e2^2+e3^2-e1^2)/(2*e2*e3));
  theta_b=acosd((e3^2+e1^2-e2^2)/(2*e3*e1));
  theta_c=acosd((e1^2+e2^2-e3^2)/(2*e1*e3));
  theta_max=max([theta_a,theta_b,theta_c]);
  theta_min=min([theta_a,theta_b,theta_c]);
  T1=
  E=sqrt((e1-e)^2+(e2-e)^2+(e3-3)^2/3)/e;
  F=min([e1,e2,e3])/max([e1,e2,e3]);
end, end
for i=2:N, for j=1:N+1-i
  i1=N+1-j; j1=N+1-i;
  e1=norm(x(:,i,j)-x(:,i-1,j+1));
  e2=norm(x(:,i,j)-x(:,i,j+1));
  e3=norm(x(:,i-1,j+1)-x(:,i,j+1));
  s=(e1+e2+e3)/2; area(i1,j1)=sqrt(s*(s-e1)*(s-e2)*(s-e3)); % Herod's formula for area of B cells
  theta_a=acosd((e2^2+e3^2-e1^2)/(2*e2*e3));
  theta_b=acosd((e3^2+e1^2-e2^2)/(2*e3*e1));
  theta_c=acosd((e1^2+e2^2-e3^2)/(2*e1*e3));
  theta_max(i,j)=max(theta_a,theta_b,theta_c);
  theta_min(i,j)=min(theta_a,theta_b,theta_c);
  E=sqrt((e1-e)^2+(e2-e)^2+(e3-3)^2/3)/e;
  F=min([e1,e2,e3])/max([e1,e2,e3]);
end, end
% The following command fits areaB into the strictly lower triangular part of areaR.
area_min=min(area,[],"all";
area_max=max(area,[],"all");
area_avg=rms(area,"all");
A1=
A2=

Erms=
Fmin=
theta_rmsd=
theta_min_max=
Aavg=
