% Test script for Cholesky and IncompleteCholesky    % Numerical Renaissance Codebase 1.0
n=5; m=5; c=0.01; A=zeros(m*n,m*n); C=-c*diag(ones(n,1),0);
B=(1+4*c)*diag(ones(n,1),0)-c*diag(ones(n-1,1),-1)-c*diag(ones(n-1,1),1);
for i=0:m-1, A(i*n+1:(i+1)*n,i*n+1:(i+1)*n)=B; end
for i=0:m-2, j=i+1; k=i+2;  A(i*n+1:j*n,j*n+1:k*n)=C;  A(j*n+1:k*n,i*n+1:j*n)=C;  end
A(1:n,(m-1)*n+1:m*n)=C;  A((m-1)*n+1:m*n,1:n)=C; n=n*m;
format +; A      % A>0 is a sparse matrix given by discretization of the 2D Helmholtz eqn.
Gfull = Cholesky(A,n)           % Gfull loses the sparsity structure of A.
Ginc  = IncompleteCholesky(A,n) % Ginc retains the sparsity structure of A.
Gdiag = diag(sqrt(diag(A)))     % Gdiag is just the square root of the diagonal of A.
format short; norm(A)           % This is a measure of A.
eGfull= norm(Gfull*Gfull'-A)    % This is near machine zero, indicating Cholesky.m works.
eGdiag= norm(Gdiag*Gdiag'-A)    % Gdiag is a "zero'th order" approximation of Gfull.
eGinc = norm(Ginc*Ginc'-A)      % Ginc is a significantly better approximation of Gfull.
