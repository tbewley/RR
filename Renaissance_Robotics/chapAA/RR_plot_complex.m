function RR_plot_complex(z,c)
% function RR_plot_complex(z,c)
% This function just generates a nice plot, with line(s) of a specified color
% from the origin to the complex value(s) in z 
% INPUT: z = scalar, vector, or matrix of complex values
% TESTS: close all, z1=0.866+0.5*i, RR_plot_complex(z1,'b-')
%        close all, RR_plot_complex(randn(5,3)+randn(5,3)*i,'b-')
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

if nargin<2, c='k-', end
origin=0
[m,n]=size(z); if m*n>1, hold on, end
for i=1:m; for j=1:n, plot([origin z(i,j)],c), end, end
axis equal, grid on
