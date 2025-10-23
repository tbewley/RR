% script RR_sphere_grid_TH
% This script develops a grid over the sphere that has TH symmetry and
% overall red/black ordering.  It starts by developing a triangular
% grid over each triangle of a Tetrakis Hexahedron, projects it to the 
% sphere, then shifts and reflects it around.  Note that 6 (triangular)
% voronoi cells meet up at their corners almost everywhere, except at 6 of
% the 14 vertices of a TH, where 4 (triangular) voronoi cells meet up.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Packings)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, n=2  % n=2,3,4,... degree of refinement of each edge (N=2^n intervals)
omega=1     % amount of stretching (0=none, 1=regular stretching, 1.1=overstretching)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=2^n, global RR_VERBOSE; figure(1), clf, figure(2), clf
fprintf('total gridpoints in spherical grid = %d\n',24*N^2)
s=sqrt(3);
A=[ s;0;0]/s; B=[ 1;1;1]/s;  C=[ 1;1;-1]/s; D=[ 1;-1;-1]/s; E=[ 1;-1;1]/s;
F=[-s;0;0]/s; G=[-1;1;1]/s;  H=[-1;1;-1]/s; I=[-1;-1;-1]/s; J=[-1;-1;1]/s;
              K=[0;s;0]/s;   L=[0;0;-s]/s;  M=[0;-s;0]/s;   O=[0;0;s]/s;
[x,xR]=RR_sphere_gen_orthant(N,omega,0,A,B,C); [x,xR]=RR_sphere_gen_orthant(N,omega,0,A,C,D);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,A,D,E); [x,xR]=RR_sphere_gen_orthant(N,omega,0,A,E,B);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,F,G,H); [x,xR]=RR_sphere_gen_orthant(N,omega,0,F,H,I);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,F,I,J); [x,xR]=RR_sphere_gen_orthant(N,omega,0,F,J,G);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,K,G,H); [x,xR]=RR_sphere_gen_orthant(N,omega,0,K,H,C);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,K,C,B); [x,xR]=RR_sphere_gen_orthant(N,omega,0,K,B,G);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,L,H,I); [x,xR]=RR_sphere_gen_orthant(N,omega,0,L,I,D);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,L,D,C); [x,xR]=RR_sphere_gen_orthant(N,omega,0,L,C,H);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,M,I,J); [x,xR]=RR_sphere_gen_orthant(N,omega,0,M,J,E);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,M,E,D); [x,xR]=RR_sphere_gen_orthant(N,omega,0,M,D,I);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,O,J,G); [x,xR]=RR_sphere_gen_orthant(N,omega,0,O,G,B);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,O,B,E); [x,xR]=RR_sphere_gen_orthant(N,omega,0,O,E,J);
view(45,64)
