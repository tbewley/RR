function [x,t]=RK435_3R(R,x,t,s,p,v,SimPlot)
% function [x,t]=RK435_3R(R,x,t,s,p,v,SimPlot)
% Simulate x'=f(x), with f implemented in R, using the 3-register RK435 method by
% Kennedy, Carpenter, & Lewis (2000).
% {x,t} contains the initial {x,t} on input and the final {x,t} on output.
% The simulation parameters are s.T (time interval of simulation) and s.h (timestep).
% The function parameters p, whatever they are, are simply passed along to R.
% If v<>0, SimPlot is called at each timestep to make interactive plots.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.4.1.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RK2, RK4, RK45, RKW3_2R, RK435_2R, RK548_3R.  Verify with RKtest.

a21= 2365592473904/ 8146167614645; a32=  4278267785271/ 6823155464066;
a43= 2789585899612/ 8986505720531; a54= 15310836689591/24358012670437;
a31= -722262345248/10870640012513; a42=  1365858020701/ 8494387045469;
a53=    3819021186/ 2763618202291; b1 =   846876320697/ 6523801458457;
b2 = 3032295699695/12397907741132; b3 =   612618101729/ 6534652265123;
b4 = 1155491934595/ 2954287928812; b5 =   707644755468/ 5028292464395;
h=s.h; if v, xold=x; told=t; end
for n=1:s.T/h  % Note: if v=0, entire computation is done in just 3 registers, {x,y,z}.
                                 z=feval(R,x,p); x=x+b1*h*z; 
  z=x+a21*h*z; y=x+(a31-b1)*h*z; z=feval(R,z,p); x=x+b2*h*z;
  z=y+a32*h*z; y=x+(a42-b2)*h*z; z=feval(R,z,p); x=x+b3*h*z;
  z=y+a45*h*z; y=x+(a53-b3)*h*z; z=feval(R,z,p); x=x+b4*h*z;
  z=y+a54*h*z;                   z=feval(R,z,p); x=x+b5*h*z; t=t+h;
  if v, feval(SimPlot,xold,x,told,t,h,h,v); xold=x; told=t; end
end
end % function RK435_3R
