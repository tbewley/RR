% script RR_sphere_grid_C
% This script develops a grid over the sphere that has cubic symmetry.
% It does NOT have overall red/black ordering.  It starts by developing a
% rectangular grid over each square of a cube, projects it to the 
% sphere, then shifts and reflects it around.  Note that 4 (quadrilateral)
% voronoi cells meet up at their corners almost everywhere, except at the
% 8 vertices of an cube, where 3 (quadrilateral) voronoi cells meet up.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Packings)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, n=2  % n=2,3,4,... degree of refinement of each edge (N=2^n intervals)
omega=1     % amount of stretching (0=none, 1=regular stretching, 1.1=overstretching)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=2^n, global RR_VERBOSE; figure(1), clf, figure(2), clf
fprintf('total gridpoints in spherical grid = %d\n',6*N^2)
s=sqrt(3); % Cube construction 
A=[ 1;1;1]/s; B=[ 1;1;-1]/s; C=[ 1;-1;-1]/s; D=[ 1;-1;1]/s;
E=[-1;1;1]/s; F=[-1;1;-1]/s; G=[-1;-1;-1]/s; H=[-1;-1;1]/s;
% Below we generate the 18 square and 8 triangular orthants of C
[x,xR]=RR_sphere_gen_orthant(N,omega,0,A,B,C,D); [x,xR]=RR_sphere_gen_orthant(N,omega,0,E,F,G,H);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,A,B,F,E); [x,xR]=RR_sphere_gen_orthant(N,omega,0,B,C,G,F);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,C,D,H,G); [x,xR]=RR_sphere_gen_orthant(N,omega,0,D,A,E,H);
view(57,19)
