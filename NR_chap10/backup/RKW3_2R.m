function [x,t]=RKW3_2R(R,x,t,s,p,v,SimPlot)
% function [x,t]=RKW3_2R(R,x,t,s,p,v,SimPlot)
% Simulate x'=f(x), with f implmented in R, using the 2-register RK3 method by Wray (1986).
% {x,t} contains the initial {x,t} on input and the final {x,t} on output.
% The simulation parameters are s.T (time interval of simulation) and s.h (timestep).
% The function parameters p, whatever they are, are simply passed along to R.
% If v<>0, SimPlot is called at each timestep to make interactive plots.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.4.1.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RK2, RK4, RK45, RK435_2R, RK435_3R, RK548_3R.  Verify with RKtest.

a21=8/15; a32=5/12; b1=1/4; b3=3/4; h=s.h; if v, xold=x; told=t; end
for n=1:s.T/h       % Note: if v=0, entire computation is done in just 2 registers, {x,y}.
                    y=feval(R,x,p); x=x+b1*h*y; 
  y=x+(a21-b1)*h*y; y=feval(R,y,p); % simplifications since b2=0
  y=x+(a32   )*h*y; y=feval(R,y,p); x=x+b3*h*y; t=t+h;
  if v, feval(SimPlot,xold,x,told,t,h,h,v); xold=x; told=t; end
end
end % function RKW3_2R
