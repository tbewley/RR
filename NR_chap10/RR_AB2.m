function [x,t,s]=RC_AB2(R,x,t,s,p,v,SimPlot)
% function [x,t,s]=RC_AB2(R,x,t,s,p,v,SimPlot)
% Simulate x'=f(x), with f implemented in R, using the AB2 method.
% {x,t} contains the initial {x,t} on input and the final {x,t} on output.
% The simulation parameters are s.MaxTime, s.MaxSteps, s.h (timestep), and s.f,
% which contains the most recent value of f on input (from, e.g., a prior call to EE/AB2),
% and the 2 most recent values of f on output (facilitating a subsequent call to AB2/AB3).
% The function parameters p, whatever they are, are simply passed along to R.
% If v<>0, SimPlot is called at each timestep to make interactive plots.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.4.2.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also EE, AB3, AB4, AB5, RC_AB6.  Verify with RC_ABtest.

if v, xold=x; end
for n=1:min((s.MaxTime-t)/s.h,s.MaxSteps)
  s.f=[feval(R,x,p) s.f(:,1)];
  x=x+s.h*(3*s.f(:,1)-s.f(:,2))/2;
  t=t+s.h; if v, feval(SimPlot,xold,x,t-s.h,t,s.h,s.h,v); xold=x; end
end
end % function RC_AB2
