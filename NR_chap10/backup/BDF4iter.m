function [x,t,s]=RC_BDF4iter(R,x,t,s,p,v,SimPlot)
% function [x,t,s]=RC_BDF4iter(R,x,t,s,p,v,SimPlot)
% Simulate x'=f(x), with f implmented in R, using the iterative BDF4 method with an eBDF4
% predictor.  t contains the initial t on input and the final t on output. x contains
% the 4 (or more) most recent values of x on input (from a call to RC_BDF3iter/RC_BDF4iter),
% and the 5 most recent values of x on output (facilitating a call to RC_BDF4iter/RC_BDF5iter).
% The simulation parameters are s.MaxTime, s.MaxSteps, s.MaxIters, s.h (timestep).
% The function parameters p, whatever they are, are simply passed along to R.
% If v<>0, SimPlot is called at each timestep to make interactive plots.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.5.3.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_IEiter, RC_BDF2iter, RC_BDF3iter, RC_BDF5iter, RC_BDF6iter.  Verify with RC_BDFtest.

for n=1:min((s.MaxTime-t)/s.h,s.MaxSteps)
  x(:,2:5)=x(:,1:4); f=feval(R,x(:,2),p);                   % Predict with eBDF4
  x(:,1)=(-10*x(:,2)+18*x(:,3)-6*x(:,4)+x(:,5)+12*s.h*f)/3;   
  for m=1:s.MaxIters, f=feval(R,x(:,1),p);                  % Iteratively correct with BDF4
    x(:,1)=(48*x(:,2)-36*x(:,3)+16*x(:,4)-3*x(:,5)+12*s.h*f)/25; 
  end
  t=t+s.h; if v, feval(SimPlot,x(:,2),x(:,1),t-s.h,t,s.h,s.h,v); end
end
end % function RC_BDF4iter
