function [x,t]=RK4(R,x,t,s,p,v,SimPlot)
% function [x,t]=RK4(R,x,t,s,p,v,SimPlot)
% Simulate x'=f(x), with f implmented in R, using the classical RK4 method.
% {x,t} contains the initial {x,t} on input and the final {x,t} on output.
% The simulation parameters are s.T (time interval of simulation) and s.h (timestep).
% The function parameters p, whatever they are, are simply passed along to R.
% If v<>0, SimPlot is called at each timestep to make interactive plots.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.4.1.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RK2, RK45, RKW3_2R, RK435_2R, RK435_3R, RK548_3R.  Verify with RKtest.

h=s.h; if v, xold=x; end
for n=1:s.T/h; 
  f1=feval(R,x,p); f2=feval(R,x+h*f1/2,p); f3=feval(R,x+h*f2/2,p); f4=feval(R,x+h*f3,p);
  x=x+h*(f1/6+(f2+f3)/3+f4/6); t=t+h;
  if v, feval(SimPlot,xold,x,t-h,t,h,h,v); xold=x; end
end
end % function RK4
