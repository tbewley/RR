function [x,res_save]=CGquadPrecon(A,b)              % Numerical Renaissance Codebase 1.0
% Minimize J=(1/2) xˆT A x - bˆT x using the cg method with preconditioning
minres=1e-20; x=0*b; alpha=0; maxiter=500;  N=size(b,1);
for i=1:N; for j=1:N; if (abs(A(i,j))>.1 | i==j); M(i,j)=A(i,j); else; M(i,j)=0; end; end; end;
nm=norm(A-M), P=sqrtm(M); conA=cond(A), conPAP=cond(inv(P)*A*inv(P)),
for iter=1:maxiter
  if (iter==1); g=A*x-b; else; g=g+alpha*d; end  % determine gradient 
  s=M\g;
  res=g'*s;                                      % compute residual
  if (mod(iter,100)==1); p=-s;                   % Set up a steepest descent step
  else;                  p=-s+(res/reso)*p;      % Set up a conjugate gradient step
  end
  d=A*p;                % <--- perform the (expensive) matrix/vector product
  alpha=res/(p'*d);                             % compute alpha
  x=x+alpha*p;                                  % update x
  if (res < minres), break; end                 % test for convergence
  reso=res;
end
end % function CGquadPrecon