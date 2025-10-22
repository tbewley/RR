% script RR_sphere_grid_T
% This script develops a grid over the sphere that has tetrahedral symmetry.
% It does NOT have overall red/black ordering.  It starts by developing a
% triangular grid over each triangle of a tetrahedron, projects it to the 
% sphere, then shifts and reflects it around.  Note that 6 (triangular)
% voronoi cells meet up at their corners almost everywhere, except at the
% 4 vertices of a tetrahedron, where 3 (triangular) voronoi cells meet up.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Packings)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, omega=1   % 0=no stretching, 1=regular stretching, 1.1 overstretching
n=3              % n=2,3,4,... 
viz='all';       % 'single', 'west', 'north', or 'all'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=2^n, global RR_VERBOSE; figure(1), clf, figure(2), clf
fprintf('total gridpoints in spherical grid = %d\n',4*N^2)
switch viz
  case 'single', orthants=1;       v=[135 -15]; RR_VERBOSE=1; % first octant only
  case 'north',  orthants=[1:3];   v=[135 35];  RR_VERBOSE=0; % northern hemisphere
  case 'all',    orthants=[1:4];   v=[135 35];  RR_VERBOSE=0; % all octants
  otherwise, error('Fix input.')
end
s=sqrt(3); a=[1;1;1]/s; b=[1;-1;-1]/s; c=[-1;1;-1]/s; d=[-1;-1;1]/s;
for orthant=1:length(orthants)
  switch orthant  % use three points (all on unit circle) to start the triangle from
    case 1, x(:,1,1)=a; x(:,N+1,1)=b; x(:,1,N+1)=c; m1='r*'; m2='r*';
    case 2, x(:,1,1)=a; x(:,N+1,1)=c; x(:,1,N+1)=d; m1='r*'; m2='r*';
    case 3, x(:,1,1)=a; x(:,N+1,1)=d; x(:,1,N+1)=b; m1='r*'; m2='r*';
    case 4, x(:,1,1)=b; x(:,N+1,1)=c; x(:,1,N+1)=d; m1='r*'; m2='r*';
  end    
  [x,xR,xB]=RR_sphere_tri_grid_compute(x,N,omega,v);
  RR_sphere_tri_grid_plot(x,xR,xB,N,m1,m2)
  [areaR,areaB]=RR_sphere_tri_grid_characterize(x,xR,xB,N);
end
RR_draw_tri3(a,b,c), RR_draw_tri3(a,c,d), RR_draw_tri3(a,d,b), RR_draw_tri3(b,c,d)
view(v(1),v(2))
