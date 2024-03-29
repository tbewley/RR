function RR_Poisson_RB_GS_Test
% function RR_Poisson_RB_GS_Test
% Apply 50 steps of red/black RR_Gauss-Seidel "smoothing" with a (checkerboard) A matrix 
% from a SOFD approximation of the 2D Poisson equation on a square grid (Example 3.3).
% The set of points updated first, which we label as "red", includes the corners.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap02
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 

disp('Now applying 50 steps of red/black RR_Gauss-Seidel smoothing to a checkerboard system.')
n=32; L=1; h=L/n; z=[2:2:n]*h; b=zeros(n+1); x=zeros(n+1); b(2:n,2:n)=randn(n-1); close all
for i=1:50
  [x]=RR_Poisson_RB_GS_Smooth(x,b,n,h);
  r=(x(2:2:n,3:2:n+1)+x(2:2:n,1:2:n-1)+x(3:2:n+1,2:2:n)+x(1:2:n-1,2:2:n) ...
     -4*x(2:2:n,2:2:n))/h^2-b(2:2:n,2:2:n);  surf(z,z,r);  pause;
end, disp(' ')
end % function RR_Poisson_RB_GS_Test
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [x]=RR_Poisson_RB_GS_Smooth(x,b,n,h)
% Apply one step of RBGS "smoothing" based on the SOFD approximation of the 2D Poisson eqn.
b1=b*0.25*h^2;
for rb=0:1, for i=2:n, m=2+mod(i+rb,2);
  x(i,m:2:n)=(x(i,m+1:2:n+1)+x(i,m-1:2:n-1)+x(i+1,m:2:n)+x(i-1,m:2:n))*0.25-b1(i,m:2:n);
end, end
end % function RR_Poisson_RB_GS_Smooth
