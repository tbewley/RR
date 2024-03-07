function [int,evals] = IntAdaptive(f,a,c,epsilon,evals,fa,fb,fc)
% function [int,evals] = IntAdaptive(f,a,c,epsilon,evals,fa,fb,fc)
% Integrate f(x) over the interval [a,c] using adaptive integration, taking b=(a+c)/2,
% where (fa,fb,fc) are the evalations at (a,b,c) and epsilon is the desired accuracy.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 9.4.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap09">Chapter 9</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also IntTrapezoidal, IntRomberg.  Verify with: IntAdaptiveTest.

b=(a+c)/2;  d=(a+b)/2;  e=(b+c)/2;  fd=f(d);  fe=f(e);  evals=evals+2;
S1=(c-a)*(fa+4*fb+fc)/6;     % Coarse and fine approximations of integral.
S2=(c-a)*(fa+4*fd+2*fb+4*fe+fc)/12;
if abs(S2-S1)/15<=epsilon    % If accuracy of S2 on desired integral is acceptable,
    int=(16*S2-S1)/15;       % take result (further refined, as in Romberg);
else                         % otherwise, split the interval into two and refine
    [int1,evals] = IntAdaptive(f,a,b,epsilon/2,evals,fa,fd,fb);  % the estimate on
    [int2,evals] = IntAdaptive(f,b,c,epsilon/2,evals,fb,fe,fc);  % both subintervals.
    int=int1+int2;
end
end % function IntAdaptive
