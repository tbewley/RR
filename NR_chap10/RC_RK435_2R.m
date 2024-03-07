function [x,t]=RK435_2R(R,x,t,s,p,v,SimPlot)
% function [x,t]=RK435_2R(R,x,t,s,p,v,SimPlot)
% Simulate x'=f(x), with f implemented in R, using the 2-register RK435 method by
% Kennedy, Carpenter, & Lewis (2000).
% {x,t} contains the initial {x,t} on input and the final {x,t} on output.
% The simulation parameters are s.T (time interval of simulation) and s.h (timestep).
% The function parameters p, whatever they are, are simply passed along to R.
% If v<>0, SimPlot is called at each timestep to make interactive plots.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.4.1.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RK2, RK4, RK45, RKW3_2R, RK435_3R, RK548_3R.  Verify with RKtest.

a21=  970286171893/ 4311952581923; a32= 6584761158862/12103376702013;
a43= 2251764453980/15575788980749; a54=26877169314380/34165994151039;
b1 = 1153189308089/22510343858157; b2 = 1772645290293/ 4653164025191; 
b3 =-1672844663538/ 4480602732383; b4 = 2114624349019/ 3568978502595;
b5 = 5198255086312/14908931495163; h=s.h; if v, xold=x; told=t; end
for n=1:s.T/h       % Note: if v=0, entire computation is done in just 2 registers, {x,y}.
                    y=feval(R,x,p); x=x+b1*h*y; 
  y=x+(a21-b1)*h*y; y=feval(R,y,p); x=x+b2*h*y;
  y=x+(a32-b2)*h*y; y=feval(R,y,p); x=x+b3*h*y;
  y=x+(a43-b3)*h*y; y=feval(R,y,p); x=x+b4*h*y;
  y=x+(a54-b4)*h*y; y=feval(R,y,p); x=x+b5*h*y; t=t+h;
  if v, feval(SimPlot,xold,x,told,t,h,h,v); xold=x; told=t; end
end
end % function RK435_2R
