function f=RHS_Lorenz(x,p)                           
f=[p.sigma*(x(2)-x(1));  -x(2)-x(1)*x(3);  -p.b*x(3)+x(1)*x(2)-p.b*p.r];
end % function RHS_Lorenz
