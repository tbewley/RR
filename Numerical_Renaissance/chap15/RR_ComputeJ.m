function [J]=ComputeJ(X,V)                           % Numerical Renaissance Codebase 1.0
J=X+X.^6+1*sin(15*X); 
if V;
  switch V; case 1, s='kx'; case 2, s='rx'; case 3, s='bx'; case 4, s='gx'; end;
  plot(X,J,s);
end
end % function ComputeJ
