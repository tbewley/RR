function RR_plot_real(z,line,point)
% function RR_plot_real(z,line,point)
% This function just generates a nice plot, with line(s) from the origin
% to the 2D or 3D vector (or matrix of several 2D or 3D vectors) in z,
% with the line(s) and the points(s) using a specified color and style
% INPUT: z = Nx1 vector, or Nxn matrix, of real values, where N=2 or 3
%        line = line style (e.g., 'b-')
%        point = point style (e.g., 'bx')
% TESTS: close all, z1=[0.866; 0.5], RR_plot_real(z1,'b-.','bx')
%        close all, RR_plot_real(randn(2,15),'r-','ro')
%        close all, RR_plot_real(randn(3,15),'k--','k*')
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

if nargin<2, c='k-', end
if nargin<3, point='kx', end
[N,n]=size(z); hold on
if N==2
  origin=[0; 0];
  for j=1:n
  	plot([origin(1) z(1,j)],[origin(2) z(2,j)],line,'LineWidth',2)
  	plot(z(1,j),z(2,j),point,'LineWidth',2,'MarkerSize',15)
  end
  axis equal, grid on
elseif N==3
  origin=[0; 0; 0];
  for j=1:n
  	plot3([origin(1) z(1,j)],[origin(2) z(2,j)],[origin(3) z(3,j)],line)
  	plot3(z(1,j),z(2,j),z(3,j),point)
  end
  view(45,20)
else
  error('Need z to have 2 or 3 rows')
end