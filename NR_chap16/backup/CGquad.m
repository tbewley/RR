function [x,res_save,x_save]=CGquad(A,b)             % Numerical Renaissance Codebase 1.0
% Minimize J=(1/2) xˆT A x - bˆT x using the conjugate gradient method
maxiter=20; minres=1e-10; x=0*b;
for iter=1:maxiter
  g=A*x-b;                                              % determine gradient
  res=g'*g; res_save(iter)=res; x_save(:,iter)=x;       % compute residual
  if (res < minres), break; end                         % test for convergence
  if (iter==1); p=-g;                                   % Set up a steepest descent step
  else;         p=-g+(res/res_old)*p;                   % Set up a conjugate gradient step
  end
  alpha=res/(p'*A*p);  x=x+alpha*p;  res_old=res;       % compute alpha and update x
end
end % function CGquad