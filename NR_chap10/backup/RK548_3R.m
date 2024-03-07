function [x,t]=RK548_3R(R,x,t,s,p,v,SimPlot)
% function [x,t]=RK548_3R(R,x,t,s,p,v,SimPlot)
% Simulate x'=f(x), with f implmented in R, using the 3-register RK548 method by
% Kennedy, Carpenter, & Lewis (2000).
% {x,t} contains the initial {x,t} on input and the final {x,t} on output.
% The simulation parameters are s.T (time interval of simulation) and s.h (timestep).
% The function parameters p, whatever they are, are simply passed along to R.
% If v<>0, SimPlot is called at each timestep to make interactive plots.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.4.1.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RK2, RK4, RK45, RKW3_2R, RK435_2R, RK435_3R.  Verify with RKtest.

a21=   141236061735/ 3636543850841; a32= 7367658691349/25881828075080;
a43=  6185269491390/13597512850793; a54= 2669739616339/18583622645114;
a65= 42158992267337/ 9664249073111; a76=  970532350048/ 4459675494195;
a87=  1415616989537/ 7108576874996; a31= -343061178215/ 2523150225462;
a42= -4057757969325/18246604264081; a53= 1415180642415/13311741862438;
a64=-93461894168145/25333855312294; a75= 7285104933991/14106269434317;
a86= -4825949463597/16828400578907; b1 =  514862045033/ 4637360145389;
b5 =  2561084526938/ 7959061818733; b6 =    4857652849/ 7350455163355;
b7 =  1059943012790/ 2822036905401; b8 = 2987336121747/15645656703944;
h=s.h; if v, xold=x; told=t; end
for n=1:s.T/h  % Note: if v=0, entire computation is done in just 3 registers, {x,y,z}.
                                 z=feval(R,x,p); x=x+b1*h*z; 
  z=x+a21*h*z; y=x+(a31-b1)*h*z; z=feval(R,z,p); % simplifications since b2=b3=b4=0 
  z=y+a32*h*z; y=x+(a42   )*h*z; z=feval(R,z,p);
  z=y+a43*h*z; y=x+(a53   )*h*z; z=feval(R,z,p);
  z=y+a54*h*z; y=x+(a64   )*h*z; z=feval(R,z,p); x=x+b5*h*z;
  z=y+a65*h*z; y=x+(a75-b5)*h*z; z=feval(R,z,p); x=x+b6*h*z;
  z=y+a76*h*z; y=x+(a86-b6)*h*z; z=feval(R,z,p); x=x+b7*h*z;
  z=y+a87*h*z;                   z=feval(R,z,p); x=x+b8*h*z; t=t+h;
  if v, feval(SimPlot,xold,x,told,t,h,h,v); xold=x; told=t; end
end
end % function RK548_3R
