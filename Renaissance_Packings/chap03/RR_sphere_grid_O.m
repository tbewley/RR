% script RR_sphere_grid_O
% This script develops a grid over the sphere that has octahedral symmetry
% and overall red/black ordering.  It starts by developing a
% triangular grid over each triangle of an octrahedron, projects it to the 
% sphere, then shifts and reflects it around.  Note that 6 (triangular)
% voronoi cells meet up at their corners almost everywhere, except at the
% 6 vertices of an octahedron, where 4 (triangular) voronoi cells meet up.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Packings)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, n=1  % n=0,1,2,3,4,... degree of refinement of each edge (N=2^n intervals)
omega=1     % amount of stretching (0=none, 1=regular stretching, 1.1=overstretching)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=3*2^n, global RR_VERBOSE; figure(1), clf, figure(2), clf
fprintf('total gridpoints in spherical grid = %d\n',8*N^2)
A=[0;0;1]; B=[0;0;-1]; C=[0;1;0]; D=[1;0;0]; E=[0;-1;0]; F=[-1;0;0];
[x,xR]=RR_sphere_gen_orthant(N,omega,1,A,C,D); [x,xR]=RR_sphere_gen_orthant(N,omega,1,A,E,F);
[x,xR]=RR_sphere_gen_orthant(N,omega,2,A,D,E); [x,xR]=RR_sphere_gen_orthant(N,omega,2,A,F,C);
[x,xR]=RR_sphere_gen_orthant(N,omega,2,B,C,D); [x,xR]=RR_sphere_gen_orthant(N,omega,2,B,E,F);
[x,xR]=RR_sphere_gen_orthant(N,omega,1,B,D,E); [x,xR]=RR_sphere_gen_orthant(N,omega,1,B,F,C);
view(57,19)
