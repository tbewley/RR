% script RR_sphere_grid_SC
% This script develops a grid over the sphere that has SC symmetry.
% It does NOT have overall red/black ordering.  It starts by developing a square/
% triangular grid over each orthant of a Square Cube, projects it to the 
% sphere, then shifts and reflects it around.  Note that 6 triangular cells,
% or 4 quadrilateral cells, or 3 triangular cells plus 2 quadrilateral cells,
% meet up at their corners almost everywhere, except at 24 of vertices
% of ths SC, where 1 quadrilateral and 4 triangular cells meet up.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Packings)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear, n=2 % n=2,3,4,... degree of refinement of each edge (N=2^n intervals)
omega=1    % amount of stretching (0=none, 1=regular stretching, 1.1=overstretching)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=2^n, global RR_VERBOSE; figure(1), clf, figure(2), clf
fprintf('total gridpoints in spherical grid = %d\n',1)
t=(1+(19+3*sqrt(33))^(1/3)+(19-3*sqrt(33))^(1/3))/3;         % tribonacci constant
r=1/t; s=sqrt(1+r^2+t^2); 
A=[1,r,t]/s;  B=[-1,-r,t]/s; C=[1,-r,-t]/s; D=[-1,r,-t]/s;   % 0 perturbations
E=[-r,1,t]/s; F=[r,-1,t]/s;  G=[r,1,-t]/s;  H=[-r,-1,-t]/s;  % 1 perturbation
I=[-t,r,1]/s; J=[t,-r,1]/s;  K=[t,r,-1]/s;  L=[-t,-r,-1]/s;
M=[-1,t,r]/s; O=[1,-t,r]/s;  P=[1,t,-r]/s;  Q=[-1,-t,-r]/s;  
R=[t,1,r]/s;  S=[t,-1,-r]/s; T=[-t,1,-r]/s; U=[-t,-1,r]/s;   % 2 perturbations
V=[r,t,1]/s;  W=[r,-t,-1]/s; X=[-r,t,-1]/s; Y=[-r,-t,1]/s;
[x,xR]=RR_sphere_gen_orthant(N,omega,1,A,E,B,F); [x,xR]=RR_sphere_gen_orthant(N,omega,1,C,G,D,H);
[x,xR]=RR_sphere_gen_orthant(N,omega,1,R,J,S,K); [x,xR]=RR_sphere_gen_orthant(N,omega,1,I,T,L,U);
[x,xR]=RR_sphere_gen_orthant(N,omega,1,V,M,X,P); [x,xR]=RR_sphere_gen_orthant(N,omega,1,O,W,Q,Y);
[x,xR]=RR_sphere_gen_orthant(N,omega,1,A,E,V  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,E,B,I  );
[x,xR]=RR_sphere_gen_orthant(N,omega,1,B,F,Y  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,F,A,J  );
[x,xR]=RR_sphere_gen_orthant(N,omega,1,C,G,K  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,G,D,X  );
[x,xR]=RR_sphere_gen_orthant(N,omega,1,D,H,L  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,H,C,W  );
[x,xR]=RR_sphere_gen_orthant(N,omega,1,R,J,A  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,J,S,O  );
[x,xR]=RR_sphere_gen_orthant(N,omega,1,S,K,C  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,K,R,P  );
[x,xR]=RR_sphere_gen_orthant(N,omega,1,I,T,M  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,T,L,D  );
[x,xR]=RR_sphere_gen_orthant(N,omega,1,L,U,Q  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,U,I,B  );
[x,xR]=RR_sphere_gen_orthant(N,omega,1,V,M,E  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,M,X,T  );
[x,xR]=RR_sphere_gen_orthant(N,omega,1,X,P,G  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,P,V,R  );
[x,xR]=RR_sphere_gen_orthant(N,omega,1,O,W,S  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,W,Q,H  );
[x,xR]=RR_sphere_gen_orthant(N,omega,1,Q,Y,U  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,Y,O,F  );
[x,xR]=RR_sphere_gen_orthant(N,omega,1,A,V,R  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,E,I,M  );
[x,xR]=RR_sphere_gen_orthant(N,omega,1,B,Y,U  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,F,J,O  );
[x,xR]=RR_sphere_gen_orthant(N,omega,1,C,W,S  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,G,K,P  );
[x,xR]=RR_sphere_gen_orthant(N,omega,1,D,X,T  ); [x,xR]=RR_sphere_gen_orthant(N,omega,1,H,L,Q  );
view(45,64)
