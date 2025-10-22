% script RR_sphere_grid_O
% This script develops a grid over the sphere that has octahedral symmetry
% and overall red/black ordering.  It starts by developing a
% triangular grid over each triangle of an octrahedron, projects it to the 
% sphere, then shifts and reflects it around.  Note that 6 (triangular)
% voronoi cells meet up at their corners almost everywhere, except at the
% 6 vertices of an octahedron, where 4 (triangular) voronoi cells meet up.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Packings)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, omega=1   % 0=no stretching, 1=regular stretching, 1.1=overstretching
n=3              % n=2,3,4,... 
viz='all';       % 'single', 'west', 'north', or 'all'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=2^n, global RR_VERBOSE; figure(1), clf, figure(2), clf
fprintf('total gridpoints in spherical grid = %d\n',8*N^2)
switch viz
  case 'single', orthants=1;       v=[135 25]; RR_VERBOSE=1; % first octant only
  case 'west',   orthants=[1:2:7]; v=[-65 -7]; RR_VERBOSE=0;  % western  hemisphere
  case 'north',  orthants=[1:4];   v=[45 64];  RR_VERBOSE=0;  % northern hemisphere
  case 'all',    orthants=[1:8];   v=[0 0];    RR_VERBOSE=0;  % all octants
end
a=[0;0;1]; b=[0;0;-1]; c=[0;1;0]; d=[1;0;0]; e=[0;-1;0]; f=[-1;0;0];
for orthant=1:length(orthants)
  switch orthants(orthant)  % use three points (all on unit circle) to start the triangle from
    case 1, x(:,1,1)=a; x(:,N+1,1)=c; x(:,1,N+1)=d; m1='r*'; m2='k*';
    case 2, x(:,1,1)=a; x(:,N+1,1)=e; x(:,1,N+1)=f; m1='r*'; m2='k*';
    case 3, x(:,1,1)=a; x(:,N+1,1)=d; x(:,1,N+1)=e; m1='k*'; m2='r*';
    case 4, x(:,1,1)=a; x(:,N+1,1)=f; x(:,1,N+1)=c; m1='k*'; m2='r*';
    case 5, x(:,1,1)=b; x(:,N+1,1)=c; x(:,1,N+1)=d; m1='k*'; m2='r*';
    case 6, x(:,1,1)=b; x(:,N+1,1)=e; x(:,1,N+1)=f; m1='k*'; m2='r*';
    case 7, x(:,1,1)=b; x(:,N+1,1)=d; x(:,1,N+1)=e; m1='r*'; m2='k*';
    case 8, x(:,1,1)=b; x(:,N+1,1)=f; x(:,1,N+1)=c; m1='r*'; m2='k*';
  end    
  [x,xR,xB]=RR_sphere_tri_grid_compute(x,N,omega,v);
  RR_sphere_tri_grid_plot(x,xR,xB,N,m1,m2)
  [areaR,areaB]=RR_sphere_tri_grid_characterize(x,xR,xB,N);
end
RR_draw_tri3(a,c,d), RR_draw_tri3(a,e,f), RR_draw_tri3(a,d,e), RR_draw_tri3(a,f,c)
RR_draw_tri3(b,c,d), RR_draw_tri3(b,e,f), RR_draw_tri3(b,d,e), RR_draw_tri3(b,f,c)
view(v(1),v(2))