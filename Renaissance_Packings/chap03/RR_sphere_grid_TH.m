% script RR_sphere_grid_TH
% This script develops a grid over the sphere that has TH symmetry and
% overall red/black ordering.  It starts by developing a triangular
% grid over each triangle of a Tetrakis Hexahedron, projects it to the 
% sphere, then shifts and reflects it around.  Note that 6 (triangular)
% voronoi cells meet up at their corners almost everywhere, except at 6 of
% the 14 vertices of a TH, where 4 (triangular) voronoi cells meet up.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Packings)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, omega=1   % 0=no stretching, 1=regular stretching, 1.1=overstretching
n=3              % n=2,3,4,... 
viz='all';       % 'single', 'west', 'north', or 'all'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=2^n, global RR_VERBOSE; figure(1), clf, figure(2), clf
fprintf('total gridpoints in spherical grid = %d\n',24*N^2)
switch viz
  case 'single', orthants=1;       v=[135 25]; RR_VERBOSE=1; % first octant only
  case 'west',   orthants=[1:2:7]; v=[-65 -7]; RR_VERBOSE=0;  % western  hemisphere
  case 'north',  orthants=[1:4];   v=[45 64];  RR_VERBOSE=0;  % northern hemisphere
  case 'all',    orthants=[1:24];  v=[0 0];    RR_VERBOSE=0;  % all octants
end
s=sqrt(3);
a=[ s;0;0]/s; b=[ 1;1;1]/s;  c=[ 1;1;-1]/s; d=[ 1;-1;-1]/s; e=[ 1;-1;1]/s;
f=[-s;0;0]/s; g=[-1;1;1]/s;  h=[-1;1;-1]/s; i=[-1;-1;-1]/s; j=[-1;-1;1]/s;
              k=[0;s;0]/s;   l=[0;0;-s]/s;  m=[0;-s;0]/s;   n=[0;0;s]/s;
for orthant=1:length(orthants)
  switch orthants(orthant)  % use {3,4} points to start each {triangle,quadrilateral} from
    case  1, x(:,1,1)=a; x(:,N+1,1)=b; x(:,1,N+1)=c; m1='r*'; m2='k*';
    case  2, x(:,1,1)=a; x(:,N+1,1)=c; x(:,1,N+1)=d; m1='k*'; m2='r*';
    case  3, x(:,1,1)=a; x(:,N+1,1)=d; x(:,1,N+1)=e; m1='r*'; m2='k*';
    case  4, x(:,1,1)=a; x(:,N+1,1)=e; x(:,1,N+1)=b; m1='k*'; m2='r*';
    case  5, x(:,1,1)=f; x(:,N+1,1)=g; x(:,1,N+1)=h; m1='r*'; m2='k*';
    case  6, x(:,1,1)=f; x(:,N+1,1)=h; x(:,1,N+1)=i; m1='k*'; m2='r*';
    case  7, x(:,1,1)=f; x(:,N+1,1)=i; x(:,1,N+1)=j; m1='r*'; m2='k*';
    case  8, x(:,1,1)=f; x(:,N+1,1)=j; x(:,1,N+1)=g; m1='k*'; m2='r*';
    case  9, x(:,1,1)=k; x(:,N+1,1)=g; x(:,1,N+1)=h; m1='k*'; m2='r*';
    case 10, x(:,1,1)=k; x(:,N+1,1)=h; x(:,1,N+1)=c; m1='r*'; m2='k*';
    case 11, x(:,1,1)=k; x(:,N+1,1)=c; x(:,1,N+1)=b; m1='k*'; m2='r*';
    case 12, x(:,1,1)=k; x(:,N+1,1)=b; x(:,1,N+1)=g; m1='r*'; m2='k*';
    case 13, x(:,1,1)=l; x(:,N+1,1)=h; x(:,1,N+1)=i; m1='r*'; m2='k*';
    case 14, x(:,1,1)=l; x(:,N+1,1)=i; x(:,1,N+1)=d; m1='k*'; m2='r*';
    case 15, x(:,1,1)=l; x(:,N+1,1)=d; x(:,1,N+1)=c; m1='r*'; m2='k*';
    case 16, x(:,1,1)=l; x(:,N+1,1)=c; x(:,1,N+1)=h; m1='k*'; m2='r*';
    case 17, x(:,1,1)=m; x(:,N+1,1)=i; x(:,1,N+1)=j; m1='k*'; m2='r*';
    case 18, x(:,1,1)=m; x(:,N+1,1)=j; x(:,1,N+1)=e; m1='r*'; m2='k*';
    case 19, x(:,1,1)=m; x(:,N+1,1)=e; x(:,1,N+1)=d; m1='k*'; m2='r*';
    case 20, x(:,1,1)=m; x(:,N+1,1)=d; x(:,1,N+1)=i; m1='r*'; m2='k*';
    case 21, x(:,1,1)=n; x(:,N+1,1)=j; x(:,1,N+1)=g; m1='r*'; m2='k*';
    case 22, x(:,1,1)=n; x(:,N+1,1)=g; x(:,1,N+1)=b; m1='k*'; m2='r*';
    case 23, x(:,1,1)=n; x(:,N+1,1)=b; x(:,1,N+1)=e; m1='r*'; m2='k*';
    case 24, x(:,1,1)=n; x(:,N+1,1)=e; x(:,1,N+1)=j; m1='k*'; m2='r*';
  end    
  [x,xR,xB]=RR_sphere_tri_grid_compute(x,N,omega,v);
  RR_sphere_tri_grid_plot(x,xR,xB,N,m1,m2)
  [areaR,areaB]=RR_sphere_tri_grid_characterize(x,xR,xB,N);
end
RR_draw_tri3(a,b,c), RR_draw_tri3(a,c,d), RR_draw_tri3(a,d,e), RR_draw_tri3(a,e,b)
RR_draw_tri3(f,g,h), RR_draw_tri3(f,h,i), RR_draw_tri3(f,i,j), RR_draw_tri3(f,j,g)
RR_draw_tri3(k,g,h), RR_draw_tri3(k,h,c), RR_draw_tri3(k,c,b), RR_draw_tri3(k,b,g)
RR_draw_tri3(l,h,i), RR_draw_tri3(l,i,d), RR_draw_tri3(l,d,c), RR_draw_tri3(l,c,h)
RR_draw_tri3(m,i,j), RR_draw_tri3(m,j,e), RR_draw_tri3(m,e,d), RR_draw_tri3(m,d,i)
RR_draw_tri3(n,j,g), RR_draw_tri3(n,g,b), RR_draw_tri3(n,b,e), RR_draw_tri3(n,e,j)
view(v(1),v(2))
