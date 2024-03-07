function [x,t,s]=RC_AM5iter(R,x,t,s,p,v,SimPlot)
% function [x,t,s]=RC_AM5iter(R,x,t,s,p,v,SimPlot)
% Simulate x'=f(x), with f implmented in R, using the iterative AM5 method with an AB5
% predictor.  {x,t} contains the initial {x,t} on input and the final {x,t} on output.
% The simulation parameters are s.MaxTime, s.MaxSteps, s.MaxIters, s.h (timestep), and s.f,
% which contains the 4-5 most recent values of f on input (from a call to RC_AM4iter/RC_AM5iter),
% and the 5 most recent values of f on output (facilitating a call to RC_AM5iter/RC_AM6iter).
% The function parameters p, whatever they are, are simply passed along to R.
% If v<>0, SimPlot is called at each timestep to make interactive plots.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 10.4.2.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap10">Chapter 10</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_CNiter, RC_AM3iter, RC_AM4iter, RC_AM6iter.  Verify with RC_AMtest.

xold=x; for n=1:min((s.MaxTime-t)/s.h,s.MaxSteps)
  if n==1 & size(s.f,2)==4                                         % n=1: Predict with AB4 
    x=xold+s.h*(55*s.f(:,1)-59*s.f(:,2)+37*s.f(:,3)-9*s.f(:,4))/24; 
  else                                                             % n>1: Predict with AB5
    x=xold+s.h*(1901*s.f(:,1)-2774*s.f(:,2)+2616*s.f(:,3)-1274*s.f(:,4)+251*s.f(:,5))/720;   
  end
  s.f(:,2:5)=s.f(:,1:4);
  for m=1:s.MaxIters, s.f(:,1)=feval(R,x,p);                % Iteratively correct with AM5
    x=xold+s.h*(251*s.f(:,1)+646*s.f(:,2)-264*s.f(:,3)+106*s.f(:,4)-19*s.f(:,5))/720;      
  end, s.f(:,1)=feval(R,x,p);
  t=t+s.h; if v, feval(SimPlot,xold,x,t-s.h,t,s.h,s.h,v); end, xold=x;
end
end % function RC_AM5iter
