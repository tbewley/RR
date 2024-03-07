function [x,t,s]=RC_BDF5iter(R,x,t,s,p,v,SimPlot)
% function [x,t,s]=RC_BDF5iter(R,x,t,s,p,v,SimPlot)
% Simulate x'=f(x), with f implmented in R, using the iterative BDF5 method with an eBDF5
% predictor.  t contains the initial t on input and the final t on output. x contains
% the 5 (or more) most recent values of x on input (from a call to RC_BDF4iter/RC_BDF5iter),
% and the 6 most recent values of x on output (facilitating a call to RC_BDF5iter/RC_BDF6iter).
% The simulation parameters are s.MaxTime, s.MaxSteps, s.MaxIters, s.h (timestep).
% The function parameters p, whatever they are, are simply passed along to R.
% If v<>0, SimPlot is called at each timestep to make interactive plots.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.5.3.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_IEiter, RC_BDF2iter, RC_BDF3iter, RC_BDF4iter, RC_BDF6iter.  Verify with RC_BDFtest.

for n=1:min((s.MaxTime-t)/s.h,s.MaxSteps)
  x(:,2:6)=x(:,1:5); f=feval(R,x(:,2),p);                   % Predict with eBDF5
  x(:,1)=(-65*x(:,2)+120*x(:,3)-60*x(:,4)+20*x(:,5)-3*x(:,6)+60*s.h*f)/12;  
  for m=1:s.MaxIters, f=feval(R,x(:,1),p);                  % Iteratively correct with BDF5
    x(:,1)=(300*x(:,2)-300*x(:,3)+200*x(:,4)-75*x(:,5)+12*x(:,6)+60*s.h*f)/137; 
  end
  t=t+s.h; if v, feval(SimPlot,x(:,2),x(:,1),t-s.h,t,s.h,s.h,v); end
end
end % function RC_BDF5iter
