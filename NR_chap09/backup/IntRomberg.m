function [int,evals] = IntRomberg(func,L,R,toplevel) % Numerical Renaissance Codebase 1.0
% Integrate func from x=L to x=R using Romberg integration, thus providing higher
% and higher order of accuracy as the grid is refined.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 9.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap09">Chapter 9</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also IntTrapezoidal, IntAdaptive.  Verify with: IntRombergTest.

evals=0;  f=[];
for level=1:toplevel
   % Approximate the integral with the trapezoidal rule on 2^level subintervals
   n=2^level;  [I(level,1),f]=IntTrapRefine(func,L,R,n,f);
   % Perform several corrections based on I at the previous level.
   for k=2:level, I(level,k)=(4^(k-1)*I(level,k-1)-I(level-1,k-1))/(4^(k-1)-1); end
end
int=I(toplevel,toplevel); evals=n+1
end % function IntRomberg.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [int,f] = IntTrapRefine(func,L,R,n,f)
% Integrate func from x=L to x=R on n equal subintervals using the trapezoidal rule,
% reusing the function evaluations have already been performed.
h=(R-L)/n;
if n==2, f(1)=func(L); f(2)=func((R+L)/2); f(3)=func(R);
else     f(1:2:n+1)=f; for j=2:2:n; f(j)=func(L+(j-1)*h); end
end
int=h*(0.5*(f(1)+f(n+1))+sum(f(2:n)));
end % function IntTrapRefine
