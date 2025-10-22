% script RR_sphere_grid_I
% This script develops a grid over the sphere that has icosahedral symmetry.
% It does NOT have overall red/black ordering.  It starts by developing a
% triangular grid over each triangle of a icosahedron, projects it to the 
% sphere, then shifts and reflects it around.  Note that 6 (triangular)
% voronoi cells meet up at their corners almost everywhere, except at the
% 12 vertices of an icosahedron, where 5 (triangular) voronoi cells meet up.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Packings)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, omega=1   % 0=no stretching, 1=regular stretching, 1.1=overstretching
n=3              % n=2,3,4,... 
viz='all';       % 'single', 'north', or 'all'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=2^n, global RR_VERBOSE; figure(1), clf, figure(2), clf
fprintf('total gridpoints in spherical grid = %d\n',4*N^2)
switch viz
  case 'single', orthants=1;       v=[135 -15]; RR_VERBOSE=1; % first orthant only
  case 'north',  orthants=[1:5];   v=[135 35];  RR_VERBOSE=0; % small hemisphere
  case 'all',    orthants=[1:20];  v=[135 35];  RR_VERBOSE=0; % all orthants
end
phi=(1+sqrt(5))/2; s=sqrt(1+phi^2); % Icosahedron construction with golden rectangles
a=[0;1;phi]/s; b=[0;1;-phi]/s; c=[0;-1;phi]/s; d=[0;-1;-phi]/s;
e=[1;phi;0]/s; f=[1;-phi;0]/s; g=[-1;phi;0]/s; h=[-1;-phi;0]/s;
i=[phi;0;1]/s; j=[-phi;0;1]/s; k=[phi;0;-1]/s; l=[-phi;0;-1]/s;
for orthant=1:length(orthants)
  switch orthants(orthant)  % use three points (all on unit circle) to start each triangle from
    case  1, x(:,1,1)=a; x(:,N+1,1)=c; x(:,1,N+1)=i; m1='r*'; m2='r*';
    case  2, x(:,1,1)=a; x(:,N+1,1)=i; x(:,1,N+1)=e; m1='r*'; m2='r*';
    case  3, x(:,1,1)=a; x(:,N+1,1)=e; x(:,1,N+1)=g; m1='r*'; m2='r*';
    case  4, x(:,1,1)=a; x(:,N+1,1)=g; x(:,1,N+1)=j; m1='r*'; m2='r*';
    case  5, x(:,1,1)=a; x(:,N+1,1)=j; x(:,1,N+1)=c; m1='r*'; m2='r*';
    case  6, x(:,1,1)=d; x(:,N+1,1)=b; x(:,1,N+1)=k; m1='r*'; m2='r*';
    case  7, x(:,1,1)=d; x(:,N+1,1)=k; x(:,1,N+1)=f; m1='r*'; m2='r*';
    case  8, x(:,1,1)=d; x(:,N+1,1)=f; x(:,1,N+1)=h; m1='r*'; m2='r*';
    case  9, x(:,1,1)=d; x(:,N+1,1)=h; x(:,1,N+1)=l; m1='r*'; m2='r*';
    case 10, x(:,1,1)=d; x(:,N+1,1)=l; x(:,1,N+1)=b; m1='r*'; m2='r*';
    case 11, x(:,1,1)=e; x(:,N+1,1)=b; x(:,1,N+1)=k; m1='r*'; m2='r*';
    case 12, x(:,1,1)=i; x(:,N+1,1)=k; x(:,1,N+1)=f; m1='r*'; m2='r*';
    case 13, x(:,1,1)=c; x(:,N+1,1)=f; x(:,1,N+1)=h; m1='r*'; m2='r*';
    case 14, x(:,1,1)=j; x(:,N+1,1)=h; x(:,1,N+1)=l; m1='r*'; m2='r*';
    case 15, x(:,1,1)=g; x(:,N+1,1)=l; x(:,1,N+1)=b; m1='r*'; m2='r*';
    case 16, x(:,1,1)=f; x(:,N+1,1)=c; x(:,1,N+1)=i; m1='r*'; m2='r*';
    case 17, x(:,1,1)=k; x(:,N+1,1)=i; x(:,1,N+1)=e; m1='r*'; m2='r*';
    case 18, x(:,1,1)=b; x(:,N+1,1)=e; x(:,1,N+1)=g; m1='r*'; m2='r*';
    case 19, x(:,1,1)=l; x(:,N+1,1)=g; x(:,1,N+1)=j; m1='r*'; m2='r*';
    case 20, x(:,1,1)=h; x(:,N+1,1)=j; x(:,1,N+1)=c; m1='r*'; m2='r*';
  end    
  [x,xR,xB]=RR_sphere_tri_grid_compute(x,N,omega,v);
  RR_sphere_tri_grid_plot(x,xR,xB,N,m1,m2)
  [areaR,areaB]=RR_sphere_tri_grid_characterize(x,xR,xB,N);
end
RR_draw_tri3(a,c,i), RR_draw_tri3(a,i,e), RR_draw_tri3(a,e,g), RR_draw_tri3(a,g,j), RR_draw_tri3(a,j,c)   
RR_draw_tri3(d,b,k), RR_draw_tri3(d,k,f), RR_draw_tri3(d,f,h), RR_draw_tri3(d,h,l), RR_draw_tri3(d,l,b)  
RR_draw_tri3(e,b,k), RR_draw_tri3(i,k,f), RR_draw_tri3(c,f,h), RR_draw_tri3(j,h,l), RR_draw_tri3(g,l,b),
RR_draw_tri3(f,c,i), RR_draw_tri3(k,i,e), RR_draw_tri3(b,e,g), RR_draw_tri3(l,g,j), RR_draw_tri3(h,j,c)   
view(v(1),v(2))
