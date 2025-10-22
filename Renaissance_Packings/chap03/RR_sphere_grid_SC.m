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

clear, omega=1   % 0=no stretching, 1=regular stretching, 1.1=overstretching
n=2              % n=2,3,4,... 
viz='all';       % 'single', 'north', or 'all'
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=2^n, global RR_VERBOSE; figure(1), clf, figure(2), clf
fprintf('total gridpoints in spherical grid = %d\n',1)  
switch viz
  case 'single', orthants=[1];   v=[135 25]; RR_VERBOSE=0; % first octant only
  case 'north',  orthants=[1:4];   v=[45 64];  RR_VERBOSE=0; % northern hemisphere
  case 'all',    orthants=[1:38];  v=[0 0];    RR_VERBOSE=0; % all octants
end
t=(1+(19+3*sqrt(33))^(1/3)+(19-3*sqrt(33))^(1/3))/3;         % tribonacci constant
r=1/t; s=sqrt(1+r^2+t^2); 
A=[1,r,t]/s;  B=[-1,-r,t]/s; C=[1,-r,-t]/s; D=[-1,r,-t]/s;   % 0 perturbations
E=[-r,1,t]/s; F=[r,-1,t]/s;  G=[r,1,-t]/s;  H=[-r,-1,-t]/s;  % 1 perturbation
I=[-t,r,1]/s; J=[t,-r,1]/s;  K=[t,r,-1]/s;  L=[-t,-r,-1]/s;
M=[-1,t,r]/s; O=[1,-t,r]/s;  P=[1,t,-r]/s;  Q=[-1,-t,-r]/s;  
R=[t,1,r]/s;  S=[t,-1,-r]/s; T=[-t,1,-r]/s; U=[-t,-1,r]/s;   % 2 perturbations
V=[r,t,1]/s;  W=[r,-t,-1]/s; X=[-r,t,-1]/s; Y=[-r,-t,1]/s;
for orthant=1:length(orthants)
  switch orthants(orthant)  % use {3,4} points to start each {triangle,quadrilateral} from
    case  1, x(:,1,1)=A; x(:,N+1,1)=E; x(:,N+1,N+1)=B; x(:,1,N+1)=F; m1='r*'; m2='k*'
    case  2, x(:,1,1)=C; x(:,N+1,1)=G; x(:,N+1,N+1)=D; x(:,1,N+1)=H; m1='r*'; m2='k*'
    case  3, x(:,1,1)=R; x(:,N+1,1)=J; x(:,N+1,N+1)=S; x(:,1,N+1)=K; m1='r*'; m2='k*'
    case  4, x(:,1,1)=I; x(:,N+1,1)=T; x(:,N+1,N+1)=L; x(:,1,N+1)=U; m1='r*'; m2='k*'
    case  5, x(:,1,1)=V; x(:,N+1,1)=M; x(:,N+1,N+1)=X; x(:,1,N+1)=P; m1='r*'; m2='k*'
    case  6, x(:,1,1)=O; x(:,N+1,1)=W; x(:,N+1,N+1)=Q; x(:,1,N+1)=Y; m1='r*'; m2='k*'
    case  7, x(:,1,1)=A; x(:,N+1,1)=E; x(:,1,N+1)=V; m1='r*'; m2='k*';
    case  8, x(:,1,1)=E; x(:,N+1,1)=B; x(:,1,N+1)=I; m1='k*'; m2='r*';
    case  9, x(:,1,1)=B; x(:,N+1,1)=F; x(:,1,N+1)=Y; m1='k*'; m2='r*';
    case 10, x(:,1,1)=F; x(:,N+1,1)=A; x(:,1,N+1)=J; m1='r*'; m2='k*';
    case 11, x(:,1,1)=C; x(:,N+1,1)=G; x(:,1,N+1)=K; m1='k*'; m2='r*';
    case 12, x(:,1,1)=G; x(:,N+1,1)=D; x(:,1,N+1)=X; m1='r*'; m2='k*';
    case 13, x(:,1,1)=D; x(:,N+1,1)=H; x(:,1,N+1)=L; m1='r*'; m2='k*';
    case 14, x(:,1,1)=H; x(:,N+1,1)=C; x(:,1,N+1)=W; m1='k*'; m2='r*';
    case 15, x(:,1,1)=R; x(:,N+1,1)=J; x(:,1,N+1)=A; m1='r*'; m2='k*';
    case 16, x(:,1,1)=J; x(:,N+1,1)=S; x(:,1,N+1)=O; m1='k*'; m2='r*';
    case 17, x(:,1,1)=S; x(:,N+1,1)=K; x(:,1,N+1)=C; m1='k*'; m2='r*';
    case 18, x(:,1,1)=K; x(:,N+1,1)=R; x(:,1,N+1)=P; m1='r*'; m2='k*';
    case 19, x(:,1,1)=I; x(:,N+1,1)=T; x(:,1,N+1)=M; m1='k*'; m2='r*';
    case 20, x(:,1,1)=T; x(:,N+1,1)=L; x(:,1,N+1)=D; m1='r*'; m2='k*';
    case 21, x(:,1,1)=L; x(:,N+1,1)=U; x(:,1,N+1)=Q; m1='r*'; m2='k*';
    case 22, x(:,1,1)=U; x(:,N+1,1)=I; x(:,1,N+1)=B; m1='k*'; m2='r*';
    case 23, x(:,1,1)=V; x(:,N+1,1)=M; x(:,1,N+1)=E; m1='r*'; m2='k*';
    case 24, x(:,1,1)=M; x(:,N+1,1)=X; x(:,1,N+1)=T; m1='k*'; m2='r*';
    case 25, x(:,1,1)=X; x(:,N+1,1)=P; x(:,1,N+1)=G; m1='r*'; m2='k*';
    case 26, x(:,1,1)=P; x(:,N+1,1)=V; x(:,1,N+1)=R; m1='k*'; m2='r*';
    case 27, x(:,1,1)=O; x(:,N+1,1)=W; x(:,1,N+1)=S; m1='k*'; m2='r*';
    case 28, x(:,1,1)=W; x(:,N+1,1)=Q; x(:,1,N+1)=H; m1='r*'; m2='k*';
    case 29, x(:,1,1)=Q; x(:,N+1,1)=Y; x(:,1,N+1)=U; m1='k*'; m2='r*';
    case 30, x(:,1,1)=Y; x(:,N+1,1)=O; x(:,1,N+1)=F; m1='r*'; m2='k*';
    case 31, x(:,1,1)=A; x(:,N+1,1)=V; x(:,1,N+1)=R; m1='r*'; m2='k*';
    case 32, x(:,1,1)=E; x(:,N+1,1)=I; x(:,1,N+1)=M; m1='k*'; m2='r*';
    case 33, x(:,1,1)=B; x(:,N+1,1)=Y; x(:,1,N+1)=U; m1='r*'; m2='k*';
    case 34, x(:,1,1)=F; x(:,N+1,1)=J; x(:,1,N+1)=O; m1='k*'; m2='r*';
    case 35, x(:,1,1)=C; x(:,N+1,1)=W; x(:,1,N+1)=S; m1='r*'; m2='k*';
    case 36, x(:,1,1)=G; x(:,N+1,1)=K; x(:,1,N+1)=P; m1='k*'; m2='r*';
    case 37, x(:,1,1)=D; x(:,N+1,1)=X; x(:,1,N+1)=T; m1='k*'; m2='r*';
    case 38, x(:,1,1)=H; x(:,N+1,1)=L; x(:,1,N+1)=Q; m1='r*'; m2='k*';
  end
  if orthants(orthant)<7,
    [x,xR]=RR_sphere_quad_grid_compute(x,N,omega,v);
    RR_sphere_quad_grid_plot(x,xR,N,m1,m2)
%    [areaR,areaB]=RR_sphere_tri_grid_characterize(x,N);
  else
    [x,xR,xB]=RR_sphere_tri_grid_compute(x,N,omega,v);
    RR_sphere_tri_grid_plot(x,xR,xB,N,m1,m2)
    [areaR,areaB]=RR_sphere_tri_grid_characterize(x,xR,xB,N);
  end
end
RR_draw_quad3(A,E,B,F), RR_draw_quad3(C,G,D,H)
RR_draw_quad3(R,J,S,K), RR_draw_quad3(I,T,L,U)
RR_draw_quad3(V,M,X,P), RR_draw_quad3(O,W,Q,Y)
RR_draw_tri3(A,E,V), RR_draw_tri3(E,B,I), RR_draw_tri3(B,F,Y), RR_draw_tri3(F,A,J)
RR_draw_tri3(C,G,K), RR_draw_tri3(G,D,X), RR_draw_tri3(D,H,L), RR_draw_tri3(H,C,W)
RR_draw_tri3(R,J,A), RR_draw_tri3(J,S,O), RR_draw_tri3(S,K,C), RR_draw_tri3(K,R,P)
RR_draw_tri3(I,T,M), RR_draw_tri3(T,L,D), RR_draw_tri3(L,U,Q), RR_draw_tri3(U,I,B)
RR_draw_tri3(V,M,E), RR_draw_tri3(M,X,T), RR_draw_tri3(X,P,G), RR_draw_tri3(P,V,R)
RR_draw_tri3(O,W,S), RR_draw_tri3(W,Q,H), RR_draw_tri3(Q,Y,U), RR_draw_tri3(Y,O,F)
RR_draw_tri3(A,V,R), RR_draw_tri3(E,I,M), RR_draw_tri3(B,Y,U), RR_draw_tri3(F,J,O)
RR_draw_tri3(C,W,S), RR_draw_tri3(G,K,P), RR_draw_tri3(D,X,T), RR_draw_tri3(H,L,Q)
view(v(1),v(2))
