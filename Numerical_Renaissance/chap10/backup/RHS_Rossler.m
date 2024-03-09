function f=RHS_Rossler(x,p)                                
f=[-x(2)-x(3);  x(1)+p.a*x(2);  p.b+x(3)*(x(1)-p.c)];
end % function RHS_Rossler
