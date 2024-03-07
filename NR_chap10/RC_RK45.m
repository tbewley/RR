function [x,t]=RK45(R,x,t,s,p,v,SimPlot)
% function [x,t]=RK45(R,x,t,s,p,v,SimPlot)
% Simulate x'=f(x), with f implemented in R, using the adaptive RK4/5 method.
% {x,t} contains the initial {x,t} on input and the final {x,t} on output.
% The simulation parameters are s.T (time interval of simulation), s.h0 (initial timestep),
% and s.epsoverT (accuracy).
% The function parameters p, whatever they are, are simply passed along to R.
% If v<>0, SimPlot is called at each timestep to make interactive plots.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.4.1.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RK2, RK4, RKW3_2R, RK435_2R, RK435_3R, RK548_3R.  Verify with RKtest.

H=s.h; if v, xold=x; told=t; end
while t<s.T, h=H/2;                           
  f1=feval(R,x,p); f2=feval(R,x+H*f1/2,p); f3=feval(R,x+H*f2/2,p); f4=feval(R,x+H*f3,p);
  X=x+H*(f1/6+(f2+f3)/3+f4/6);      % calculate X using one RK4 step with timestep H

  f1=feval(R,x,p); f2=feval(R,x+h*f1/2,p); f3=feval(R,x+h*f2/2,p); f4=feval(R,x+h*f3,p);
  x=x+h*(f1/6+(f2+f3)/3+f4/6);   
  f1=feval(R,x,p); f2=feval(R,x+h*f1/2,p); f3=feval(R,x+h*f2/2,p); f4=feval(R,x+h*f3,p);
  x=x+h*(f1/6+(f2+f3)/3+f4/6);      % calculate x using two RK4 steps with timestep h=H/2;

  delta=norm(x-X,1)/15;                      % estimate error of new x and use that to
  x=(x*16-X)/15; t=t+H;                      % update old x using fifth-order formula
  H=min(H*(H*s.epsoverT/delta)^(1/4),s.T-t); % update H based on error estimate
  if v, feval(SimPlot,xold,x,told,t,2*h,H,v); xold=x; told=t; end
end  
end % function RK45
