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
s=sqrt(3); A=[1;1;1]/s; B=[1;-1;-1]/s; C=[-1;1;-1]/s; D=[-1;-1;1]/s;
[x,xR]=RR_sphere_gen_orthant(N,omega,0,A,B,C); [x,xR]=RR_sphere_gen_orthant(N,omega,0,A,C,D);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,A,D,B); [x,xR]=RR_sphere_gen_orthant(N,omega,0,B,C,D);
view(135,35)
