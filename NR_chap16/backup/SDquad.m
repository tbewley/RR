function [x,res_save,x_save]=SDquad(A,b)             % Numerical Renaissance Codebase 1.0
% Minimize J=(1/2) xˆT A x - bˆT x using the steepest descent method
maxiter=20; minres=1e-10; x=0*b;
for iter=1:maxiter
  g=A*x-b;                                              % determine gradient
  res=g'*g; res_save(iter)=res; x_save(:,iter)=x;       % compute residual
  if (res < minres), break; end                         % test for convergence
  alpha=res/(g'*A*g);                                   % compute alpha
  x=x-alpha*g;                                          % update x
end
end % function SDquad
