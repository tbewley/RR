function [int,evals] = IntRomberg(f,L,R,toplevel)
% function [int,evals] = IntRomberg(f,L,R,toplevel)
% Integrate f(x) from x=L to x=R using Romberg integration, thus providing higher
% and higher order of accuracy as the grid is refined.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 9.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap09">Chapter 9</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also IntTrapezoidal, IntAdaptive.  Verify with: IntRombergTest.

fi=[];     % note: fi stores the previous evaluations of f(x), so they may be reused.
for level=1:toplevel
  % Approximate the integral with the trapezoidal rule on 2^level subintervals
  n=2^level;  [I(level,1),fi]=IntTrapezoidalRefine(f,L,R,n,fi);
  % Perform several corrections based on I at the previous level.
  for k=2:level, I(level,k)=(4^(k-1)*I(level,k-1)-I(level-1,k-1))/(4^(k-1)-1); end
end
int=I(toplevel,toplevel); evals=n+1
end % function IntRomberg.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [int,fi] = IntTrapezoidalRefine(f,L,R,n,fi)
% Integrate f(x) from x=L to x=R on n equal subintervals using the trapezoidal rule,
% reusing the function evaluations (stored in fi) that have already been performed.
h=(R-L)/n;
if n==2, fi(1)=f(L);  fi(2)=f((R+L)/2); fi(3)=f(R);
else,    fi(1:2:n+1)=fi; for j=2:2:n; fi(j)=f(L+(j-1)*h); end
end
int=h*(0.5*(fi(1)+fi(n+1))+sum(fi(2:n)));
end % function IntTrapezoidalRefine
