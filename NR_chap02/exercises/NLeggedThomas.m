function [G,e] = NLeggedThomas(A,B,C,G,d,e,n,p)
% function [G,e] = NLeggedThomas(A,B,C,G,d,e,n,p)
% For m=1, this function solves the set of n+1 simultaneous systems of equations 
%     /     \                                               / X_1(p,:) \
% A_i | X_i | = G_i   for i=1,...,n,    [ d_1 ... d_(n+1) ] |   :      | = e
%     \  y  /                                               | X_n(p,:) |
%                                                           \  y       /
% for the (p*n+1) unknowns {X_1,...,X_n,y}, where X_i is p x 1.
% For m>1, this function solves m such sets of systems.
%
% {A,B,C} are column matrices of size p x n; the i'th columns of {A,B,C} are the three
% diagonals of the p x p+1 tridiagonal matrices A_i.  d is a row vector of length n+1.
% {X,G} are tensors of size p x n x m.  {y,e} are row vectors of length m.
%
% Numerical Renaissance Codebase 1.0, NRchap2; see text for copyleft info.

% STEP 1. apply the forward sweeps of Thomas to the A_i problems for i=1,...,n.
% Note that the following loop can be executed on n separate CPUs, if available.
for i=1:n; for j=1:p-1,                                
  A(j+1,i)   = - A(j+1,i) / B(j,i);          % Forward sweep of the A_i problem.
  B(j+1,i)   = B(j+1,i)   + A(j+1,i)*C(j,i);       
  G(j+1,i,:) = G(j+1,i,:) + A(j+1,i)*G(j,i,:);     
end; end

% STEP 2. concatonate the last row of each modified A_i problems with the D problem.
D=zeros(n+1,n+1);
for i=1:n; D(i,i)=B(p,i); D(i,n+1)=C(p,i); E(i,:)=G(p,i,:); end, D(n+1,:)=d; E(n+1,:)=e;

% STEP 3. solve the (n+1)x(n+1) system in step 2, and put results back in the right place.
E=D\E; for i=1:n; G(p,i,:)=E(i,:); end; e=E(n+1,:);

% STEP 4. apply the backsubstitutions of Thomas to the A_i problems for i=1,...,n.
% Note that the following loop can be executed on n separate CPUs, if available.
for i=1:n; for j=p-1:-1:1,
      G(j,i,:) = ( G(j,i,:) - C(j,i) * G(j+1,i,:) ) / B(j,i);
end; end
end % function NLeggedThomas.m