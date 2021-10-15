function v=PolyVal(p,x)                              % Numerical Renaissance Codebase 1.0
n=length(p); v=0; for i=0:n-1; v=v+p(n-i)*x^i; end;
end % function PolyVal.m
