% script RR_sphere_grid_RCO
% This script develops a grid over the sphere that has RCO symmetry
% and overall red/black ordering.  It starts by developing a square/
% triangular grid over each orthant of a Rhombicuboctahedron, projects it to the 
% sphere, then shifts and reflects it around.  Note that 1 triangular cell
% plus 3 quadrilateral cells, meet up at the vertices of the RC.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Packings)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, n=2 % n=2,3,4,... degree of refinement of each edge (N=2^n intervals)
omega=1    % amount of stretching (0=none, 1=regular stretching, 1.1=overstretching)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=2^n, figure(1), clf, figure(2), clf
fprintf('total gridpoints in spherical grid = %d\n',1) 
t=1+sqrt(2); s=sqrt(1+1+t^2);  % Below are the vertices of RCO
A=[1,1, t]/s;  B=[1,-1, t]/s;  C=[-1,-1, t]/s; D=[-1,1, t]/s; % near N pole
E=[1,1,-t]/s;  F=[1,-1,-t]/s;  G=[-1,-1,-t]/s; H=[-1,1,-t]/s; % near S pole
I=[1, t,1]/s;  J=[-1, t,1]/s;  K=[-1, t,-1]/s; L=[1, t,-1]/s; % near 0 lat,   0 long
M=[1,-t,1]/s;  O=[-1,-t,1]/s;  P=[-1,-t,-1]/s; Q=[1,-t,-1]/s; % near 0 lat, 180 long
R=[ t,1,1]/s;  S=[ t,-1,1]/s;  T=[ t,-1,-1]/s; U=[ t,1,-1]/s; % near 0 lat,  90 long
V=[-t,1,1]/s;  W=[-t,-1,1]/s;  X=[-t,-1,-1]/s; Y=[-t,1,-1]/s; % near 0 lat, 270 long
% Below we generate the 18 square and 8 triangular orthants of RCO
[x,xR]=RR_sphere_gen_orthant(N,omega,1,A,B,C,D); [x,xR]=RR_sphere_gen_orthant(N,omega,1,E,F,G,H); % {N,S} poles
[x,xR]=RR_sphere_gen_orthant(N,omega,1,I,J,K,L); [x,xR]=RR_sphere_gen_orthant(N,omega,1,M,O,P,Q); % 0 lat, {0,180} long
[x,xR]=RR_sphere_gen_orthant(N,omega,1,R,S,T,U); [x,xR]=RR_sphere_gen_orthant(N,omega,1,V,W,X,Y); % 0 lat, {90,270} long
[x,xR]=RR_sphere_gen_orthant(N,omega,2,A,B,S,R); [x,xR]=RR_sphere_gen_orthant(N,omega,2,B,C,O,M);
[x,xR]=RR_sphere_gen_orthant(N,omega,2,C,D,V,W); [x,xR]=RR_sphere_gen_orthant(N,omega,2,D,A,I,J);
[x,xR]=RR_sphere_gen_orthant(N,omega,2,E,F,T,U); [x,xR]=RR_sphere_gen_orthant(N,omega,2,F,G,P,Q);
[x,xR]=RR_sphere_gen_orthant(N,omega,2,G,H,Y,X); [x,xR]=RR_sphere_gen_orthant(N,omega,2,H,E,L,K);
[x,xR]=RR_sphere_gen_orthant(N,omega,2,S,M,Q,T); [x,xR]=RR_sphere_gen_orthant(N,omega,2,O,W,X,P);
[x,xR]=RR_sphere_gen_orthant(N,omega,2,V,J,K,Y); [x,xR]=RR_sphere_gen_orthant(N,omega,2,I,R,U,L);
[x,xR]=RR_sphere_gen_orthant(N,omega,1,A,I,R  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,B,M,S  );
[x,xR]=RR_sphere_gen_orthant(N,omega,1,C,O,W  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,D,J,V  );
[x,xR]=RR_sphere_gen_orthant(N,omega,1,E,L,U  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,F,Q,T  );
[x,xR]=RR_sphere_gen_orthant(N,omega,1,G,P,X  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,H,K,Y  );
view(23,32) % set a nice initial viewpoint
%   [areaR,areaB]=RR_sphere_quad_grid_characterize(x,N);
%   [areaR,areaB]=RR_sphere_tri_grid_characterize(x,N);

