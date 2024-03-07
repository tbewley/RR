function [x,x1,x2] = FalsePosition(x1,x2,tolerance,f1,f2)
% This function refines the bracket of a root with the false position algorithm.
if nargin<5, f1=Computef(x1); f2=Computef(x2); end,  if nargin<3, tolerance=1e-5; end
while x2-x1>tolerance
   interval=x2-x1;  fprime=(f2-f1)/interval;  x=x1 - f1/fprime;
   % Ad hoc check:  reset to bisection technique if update by false position is too small.
   tol1 = interval/10;  if ((x-x1) < tol1 | (x2-x) < tol1), x = (x1+x2)/2;  end
   % Now perform the function evaluation and update the bracket.
   f = compute_f(x);
   if f_lower*f < 0,  x2 = x;  f2 = f;
   else,              x1 = x;  f1 = f;  end
end
x = (x2 + x1)/2;
% end function FalsePosition.m
