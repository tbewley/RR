function f=RHS_Lorenz(y,p)                           % Numerical Renaissance Codebase 1.0
f=[p.sigma*(y(2)-y(1));  -y(2)-y(1)*y(3);  -p.b*y(3)+y(1)*y(2)-p.b*p.r];
end % function RHS_Lorenz.m