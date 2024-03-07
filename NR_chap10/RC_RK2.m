function [x,t]=RK2(R,x,t,s,p,v,SimPlot)
% function [x,t]=RK2(R,x,t,s,p,v,SimPlot)
% Simulate x'=f(x), with f implemented in R, using the RK2(c) method, where c=1/2 is
% known as the "midpoint" method, and c=1 is a prototypical "predictor/corrector" method.
% {x,t} contains the initial {x,t} on input and the final {x,t} on output.
% The simulation parameters are s.c (described above), s.T (time interval), s.h (timestep).
% The function parameters p, whatever they are, are simply passed along to R.
% If v<>0, SimPlot is called at each timestep to make interactive plots.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.4.1.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RK4, RK45, RKW3_2R, RK435_2R, RK435_3R, RK548_3R.  Verify with RKtest.

h=s.h; c1=1/(2*s.c); if v, xold=x; end
for n=1:s.T/h; 
  f1=feval(R,x,p); f2=feval(R,x+h*s.c*f1,p);
  x=x+h*((1-c1)*f1+c1*f2); t=t+h;
  if v, feval(SimPlot,xold,x,t-h,t,h,h,v); xold=x; end
end
end % function RK2
