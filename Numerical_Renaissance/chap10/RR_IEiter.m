function [x,t,s]=RR_IEiter(R,x,t,s,p,v,SimPlot)
% function [x,t,s]=RR_IEiter(R,x,t,s,p,v,SimPlot)
% Simulate x'=f(x), with f implemented in R, using the iterative IE method with an EE
% predictor.  t contains the initial t on input and the final t on output. x contains
% the most recent value of x on input,
% and the 2 most recent values of x on output (facilitating a call to RR_BDF2iter).
% The simulation parameters are s.MaxTime, s.MaxSteps, s.MaxIters, s.h (timestep).
% The function parameters p, whatever they are, are simply passed along to R.
% If v<>0, SimPlot is called at each timestep to make interactive plots.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.5.3.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RR_BDF2iter, RR_BDF3iter, RR_BDF4iter, RR_BDF5iter, RR_BDF6iter.  Trial: RR_BDFtest.

for n=1:min((s.MaxTime-t)/s.h,s.MaxSteps)
  x(:,2)=x(:,1); f=feval(R,x(:,2),p);                       % Predict with EE
  x(:,1)=x(:,2)+s.h*f;                                    
  for m=1:s.MaxIters, f=feval(R,x(:,1),p);                  % Iteratively correct with IE
    x(:,1)=x(:,2)+s.h*f;                       
  end
  t=t+s.h; if v, feval(SimPlot,x(:,2),x(:,1),t-s.h,t,s.h,s.h,v); end
end
end % function RR_IEiter
