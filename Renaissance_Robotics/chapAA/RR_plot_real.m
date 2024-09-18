function RR_plot_real(z,c)
% This function just generates a nice plot, with line(s) of a specified color
% from the origin to the 2D or 3D vector (or matrix of several 2D or 3D vectors) in z   
% INPUT: z = Nx1 vector, or Nxn matrix, of real values, where N=2 or 3
% TESTS: close all, z1=[0.866; 0.5], RR_plot_real(z1,'b-')
%        close all, RR_plot_real(randn(2,15),'b-')
%        close all, RR_plot_real(randn(3,15),'b-')

if nargin<2, c='k-', end
[N,n]=size(z); if n>1, hold on, end
if N==2
  origin=[0; 0];
  for j=1:n, plot([origin(1) z(1,j)],[origin(2) z(2,j)],c), end
  axis equal, grid on
elseif N==3
  origin=[0; 0; 0];
  for j=1:n, plot3([origin(1) z(1,j)],[origin(2) z(2,j)],[origin(3) z(3,j)],c), end
  view(45,20)
else
  error('Need z to have 2 or 3 rows')
end