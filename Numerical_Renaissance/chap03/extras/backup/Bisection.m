function [x,x1,x2] = Bisection (x1,x2,tolerance,f1,f2)
% This function refines the bracket of a root with the bisection algorithm.
if nargin < 5, f1=Computef(x1); f2=Computef(x2); end
interval=x2-x1;  if nargin < 3, tolerance=1e-5; end
while interval > tolerance
   x = (x2 + x1)/2;  f = Computef(x);
   if f1*f<0, x2 = x; f2 = f;
   else,      x1 = x; f1 = f; end
   interval=interval/2;
end
x = (x2 + x1)/2;
% end function Bisection
