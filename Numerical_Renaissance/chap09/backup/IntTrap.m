function [int,evals] = IntTrap(func,L,R,n)           % Numerical Renaissance Codebase 1.0
% Integrate func from x=L to x=R on n equal subintervals using the trapezoidal rule.
h=(R-L)/n;   int=0.5*(func(L)+func(R));
for i=1:n-1, x=L+h*i;  int=int+func(x);  end 
int=h*int;  evals=n+1;
% end IntTrap 
