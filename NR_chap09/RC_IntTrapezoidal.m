function [int,evals] = IntTrapezoidal(f,L,R,n)           
% function [int,evals] = IntTrapezoidal(f,L,R,n)           
% Integrate f(x) from x=L to x=R on n equal subintervals using the trapezoidal rule.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 9.1.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap09">Chapter 9</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also IntRomberg, IntAdaptive.  Verify with: IntTrapezoidalTest.

h=(R-L)/n; int=(f(L)+f(R))/2; for i=1:n-1, x=L+h*i; int=int+f(x); end, int=h*int; evals=n+1
% end IntTrapezoidal 
