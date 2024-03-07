function [x,res_save]=CGquadFast(A,b)                % Numerical Renaissance Codebase 1.0
% Minimize J=(1/2) xˆT A x - bˆT x using the standard cg method (fast implementation)
minres=1e-20; x=0*b; alpha=0; maxiter=500;
for iter=1:maxiter
  if (iter==1); g=A*x-b; else; g=g+alpha*d; end         % determine gradient 
  res=g'*g;  res_save(iter)=res;                        % compute residual
  if (res < minres), break; end                         % test for convergence
  if (iter==1);          p=-g;                          % Set up a steepest descent step
  else;                  p=-g+(res/res_old)*p;          % Set up a conjugate gradient step
  end
  d=A*p;                % <--- perform the (expensive) matrix/vector product
  alpha=res/(p'*d);  x=x+alpha*p;  res_old=res;         % compute alpha and update x
end; iter
end % function CGquadFast