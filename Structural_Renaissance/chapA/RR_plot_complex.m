function RR_plot_complex(z,line,point)
% function RR_plot_complex(z,line,point)
% This function just generates a nice plot, with line(s) from the origin
% to the complex value(s) in z, 
% with the line(s) and the points(s) using a specified color and style
% INPUT: z = scalar, vector, or matrix of complex values
%        line = line style (e.g., 'b-')
%        point = point style (e.g., 'bx')
% TESTS: close all, z1=0.866+0.5*i, RR_plot_complex(z1,'b-.','bx')
%        close all, RR_plot_complex(randn(5,3)+randn(5,3)*i,'r-','rx')
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

if nargin<2, line='k-', end
if nargin<3, point='kx', end
origin=0
[m,n]=size(z); hold on
for i=1:m; for j=1:n
   plot([origin z(i,j)],line,'LineWidth',2)
   plot([z(i,j)],      point,'LineWidth',2,'MarkerSize',15)
end, end
axis equal, grid on
