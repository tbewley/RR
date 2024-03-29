% script <a href="matlab:RR_BilinearSplineTest">RR_BilinearSplineTest</a>
% Test <a href="matlab:help RR_BilinearSpline">RR_BilinearSpline</a> on data from a smooth fn.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 7)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

close all, clear; Lx=17; Ly=30; ep=.00001; xmin=-Lx/2; xmax=Lx/2; ymin=-Ly/2; ymax=Ly/2;
ndx=10;  ndy=20;  xd=[xmin:Lx/(ndx-1):xmax]; yd=[ymin:Ly/(ndy-1):ymax];
nfx=100; nfy=100; x =[xmin:Lx/(nfx-1):xmax]; y =[ymin:Ly/(nfy-1):ymax];
for i=1:ndx, for j=1:ndy, r=sqrt(xd(i)^2+yd(j)^2)+ep; fd(i,j)=sin(r)/r; end, end
for i=1:nfx, for j=1:nfy, r=sqrt(x (i)^2+y (j)^2)+ep; ff(i,j)=sin(r)/r; end, end
figure(1); mesh(yd,xd,fd), view(-11.5,14), figure(2); mesh(y,x,ff), view(-11.5,14)
BLS=RR_BilinearSpline(x,y,xd,yd,fd); figure(3); mesh(y,x,BLS), view(-11.5,14)

% end script RR_BilinearSplineTest
