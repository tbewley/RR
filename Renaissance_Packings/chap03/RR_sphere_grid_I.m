% script RR_sphere_grid_I
% This script develops a grid over the sphere that has icosahedral symmetry.
% It does NOT have overall red/black ordering.  It starts by developing a
% triangular grid over each triangle of a icosahedron, projects it to the 
% sphere, then shifts and reflects it around.  Note that 6 (triangular)
% voronoi cells meet up at their corners almost everywhere, except at the
% 12 vertices of an icosahedron, where 5 (triangular) voronoi cells meet up.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Packings)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, n=2  % n=2,3,4,... degree of refinement of each edge (N=2^n intervals)
omega=1     % amount of stretching (0=none, 1=regular stretching, 1.1=overstretching)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=2^n, global RR_VERBOSE; figure(1), clf, figure(2), clf
fprintf('total gridpoints in spherical grid = %d\n',4*N^2)
phi=(1+sqrt(5))/2; s=sqrt(1+phi^2); % Icosahedron construction with golden rectangles
A=[0;1;phi]/s; B=[0;1;-phi]/s; C=[0;-1;phi]/s; D=[0;-1;-phi]/s;
E=[1;phi;0]/s; F=[1;-phi;0]/s; G=[-1;phi;0]/s; H=[-1;-phi;0]/s;
I=[phi;0;1]/s; J=[-phi;0;1]/s; K=[phi;0;-1]/s; L=[-phi;0;-1]/s;
[x,xR]=RR_sphere_gen_orthant(N,omega,0,A,C,I); [x,xR]=RR_sphere_gen_orthant(N,omega,0,A,I,E);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,A,E,G); [x,xR]=RR_sphere_gen_orthant(N,omega,0,A,G,J);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,A,J,C); [x,xR]=RR_sphere_gen_orthant(N,omega,0,D,B,K);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,D,K,F); [x,xR]=RR_sphere_gen_orthant(N,omega,0,D,F,H);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,D,H,L); [x,xR]=RR_sphere_gen_orthant(N,omega,0,D,L,B);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,E,B,K); [x,xR]=RR_sphere_gen_orthant(N,omega,0,I,K,F);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,C,F,H); [x,xR]=RR_sphere_gen_orthant(N,omega,0,J,H,L);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,G,L,B); [x,xR]=RR_sphere_gen_orthant(N,omega,0,F,C,I);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,K,I,E); [x,xR]=RR_sphere_gen_orthant(N,omega,0,B,E,G);
[x,xR]=RR_sphere_gen_orthant(N,omega,0,L,G,J); [x,xR]=RR_sphere_gen_orthant(N,omega,0,H,J,C);
view(135,35)
