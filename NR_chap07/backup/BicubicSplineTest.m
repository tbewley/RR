% script <a href="matlab:RC_BicubicSplineTest">RC_BicubicSplineTest</a>
% Test <a href="matlab:help RC_BicubicSpline">RC_BicubicSpline</a> on data from a smooth fn.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

close all, clear; Lx=17; Ly=30; ep=.00001; xmin=-Lx/2; xmax=Lx/2; ymin=-Ly/2; ymax=Ly/2;
ndx=10;  ndy=20;  xd=[xmin:Lx/(ndx-1):xmax]; yd=[ymin:Ly/(ndy-1):ymax];
nfx=100; nfy=100; x =[xmin:Lx/(nfx-1):xmax]; y =[ymin:Ly/(nfy-1):ymax];
for i=1:ndx, for j=1:ndy, r=sqrt(xd(i)^2+yd(j)^2)+ep; fd(i,j)=sin(r)/r; end, end
for i=1:nfx, for j=1:nfy, r=sqrt(x (i)^2+y (j)^2)+ep; ff(i,j)=sin(r)/r; end, end
figure(1), mesh(yd,xd,fd), view(-11.5,14), figure(2), mesh(y,x,ff), view(-11.5,14)
[fx,fy,fxy,Ainv]=RC_BicubicSplineSetup(xd,yd,fd,'parabolic');
BCS=RC_BicubicSpline(x,y,xd,yd,fd,fx,fy,fxy,Ainv); figure(3), mesh(y,x,BCS), view(-11.5,14)

% end script RC_BicubicSplineTest
