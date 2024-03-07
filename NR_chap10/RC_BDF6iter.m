function [x,t,s]=RC_BDF6iter(R,x,t,s,p,v,SimPlot)
% function [x,t,s]=RC_BDF6iter(R,x,t,s,p,v,SimPlot)
% Simulate x'=f(x), with f implemented in R, using the iterative BDF6 method with an eBDF6
% predictor.  t contains the initial t on input and the final t on output. x contains
% the 6 most recent values of x on input (from a call to RC_BDF5iter/RC_BDF6iter),
% and the 7 most recent values of x on output (facilitating a call to RC_BDF6iter).
% The simulation parameters are s.MaxTime, s.MaxSteps, s.MaxIters, s.h (timestep).
% The function parameters p, whatever they are, are simply passed along to R.
% If v<>0, SimPlot is called at each timestep to make interactive plots.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.5.3.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_IEiter, RC_BDF2iter, RC_BDF3iter, RC_BDF4iter, RC_BDF5iter.  Verify with RC_BDFtest.

for n=1:min((s.MaxTime-t)/s.h,s.MaxSteps)
  x(:,2:7)=x(:,1:6); f=feval(R,x(:,2),p);                  % Predict with eBDF6
  x(:,1)=(-77*x(:,2)+150*x(:,3)-100*x(:,4)+50*x(:,5)-15*x(:,6)+2*x(:,7)+60*s.h*f)/10; 
  for m=1:s.MaxIters, f=feval(R,x(:,1),p);                 % Iteratively correct with BDF6
    x(:,1)=(360*x(:,2)-450*x(:,3)+400*x(:,4)-225*x(:,5)+72*x(:,6)-10*x(:,7)+60*s.h*f)/147;  
  end
  t=t+s.h; if v, feval(SimPlot,x(:,2),x(:,1),t-s.h,t,s.h,s.h,v); end
end
end % function RC_BDF6iter
