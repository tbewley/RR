function [x,evals]=RR_Bisection(x1,x2,Compute_f,tol,verbose,p)     
% function [x,evals]=RR_Bisection(x1,x2,Compute_f,tol,verbose,p)
% This function refines the bracket of a root with the bisection algorithm.
% See also FindRootBracket, FalsePosition.  Trial: BisectionTest.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap03
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 

f1=Compute_f(x1,verbose,p); f2=Compute_f(x2,verbose,p); evals=2;
while x2-x1>tol
   x = (x2 + x1)/2; f=Compute_f(x,verbose,p); evals=evals+1;
   if f1*f<0, x2=x; f2=f;
   else,      x1=x; f1=f; end
end
x=(x2+x1)/2;
end % function RR_Bisection
