% script RR_sphere_grid_C
% This script develops a grid over the sphere that has cubic symmetry.
% It does NOT have overall red/black ordering.  It starts by developing a
% rectangular grid over each square of a cube, projects it to the 
% sphere, then shifts and reflects it around.  Note that 4 (quadrilateral)
% voronoi cells meet up at their corners almost everywhere, except at the
% 8 vertices of an cube, where 3 (quadrilateral) voronoi cells meet up.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Packings)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, omega=1   % 0=no stretching, 1=regular stretching, 1.1=overstretching
n=3              % n=2,3,4,... 
viz='all';       % 'single', 'north', or 'all'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=2^n, global RR_VERBOSE; figure(1), clf, figure(2), clf
fprintf('total gridpoints in spherical grid = %d\n',6*N^2)
switch viz
  case 'single', orthants=[1];    v=[135 -15]; RR_VERBOSE=1; % first orthant only
  case 'north',  orthants=[1:5];  v=[135 35];  RR_VERBOSE=0; % small hemisphere
  case 'all',    orthants=[1:20]; v=[153 19];  RR_VERBOSE=0; % all orthants
end
s=sqrt(3); % Cube construction 
a=[ 1;1;1]/s; b=[ 1;1;-1]/s; c=[ 1;-1;-1]/s; d=[ 1;-1;1]/s;
e=[-1;1;1]/s; f=[-1;1;-1]/s; g=[-1;-1;-1]/s; h=[-1;-1;1]/s;
for orthant=1:length(orthants)
  switch orthants(orthant)  % use four points (all on unit circle) to start each square from
    case  1, x(:,1,1)=a; x(:,N+1,1)=b; x(:,N+1,N+1)=c; x(:,1,N+1)=d; m1='r*'; m2='r*';
    case  2, x(:,1,1)=e; x(:,N+1,1)=f; x(:,N+1,N+1)=g; x(:,1,N+1)=h; m1='r*'; m2='r*';
    case  3, x(:,1,1)=a; x(:,N+1,1)=b; x(:,N+1,N+1)=f; x(:,1,N+1)=e; m1='r*'; m2='r*';
    case  4, x(:,1,1)=b; x(:,N+1,1)=c; x(:,N+1,N+1)=g; x(:,1,N+1)=f; m1='r*'; m2='r*';
    case  5, x(:,1,1)=c; x(:,N+1,1)=d; x(:,N+1,N+1)=h; x(:,1,N+1)=g; m1='r*'; m2='r*';
    case  6, x(:,1,1)=d; x(:,N+1,1)=a; x(:,N+1,N+1)=e; x(:,1,N+1)=h; m1='r*'; m2='r*';
  end    
  [x,xR]=RR_sphere_quad_grid_compute(x,N,omega,v);
  RR_sphere_quad_grid_plot(x,xR,N,m1,m2)
%  [areaR,areaB]=RR_sphere_quad_grid_characterize(x,xR,xB,N);
end
RR_draw_quad3(a,b,c,d), RR_draw_quad3(e,f,g,h), RR_draw_quad3(a,b,f,e)
RR_draw_quad3(b,c,g,f), RR_draw_quad3(c,d,h,g), RR_draw_quad3(d,a,e,h) 
view(v(1),v(2))
