function f=RHS_Rossler(y,p)                          % Numerical Renaissance Codebase 1.0
f=[-y(2)-y(3);  y(1)+p.a*y(2);  p.b+y(3)*(y(1)-p.c)];
end % function RHS_Rossler.m