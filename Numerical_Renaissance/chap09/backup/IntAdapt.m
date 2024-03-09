function [int,evals] = IntAdapt(func,a,c,epsilon,evals,fa,fb,fc)
% Numerical Renaissance Codebase 1.0
% Integrate func over the interval [a,c] using adaptive integration, taking b=(a+c)/2,
% where (fa,fb,fc) are the evalations at (a,b,c) and epsilon is the desired accuracy.
b=(a+c)/2;  d=(a+b)/2;  e=(b+c)/2;  fd=func(d);  fe=func(e);  evals=evals+2;
S1=(c-a)*(fa+4*fb+fc)/6;     % Coarse and fine approximations of integral.
S2=(c-a)*(fa+4*fd+2*fb+4*fe+fc)/12;
if abs(S2-S1)/15<=epsilon    % If accuracy of S2 on desired integral is acceptable,
    int=(16*S2-S1)/15;       % take result (further refined, as in Romberg);
else                         % otherwise, split the interval into two and refine
    [int1,evals] = IntAdapt(func,a,b,epsilon/2,evals,fa,fd,fb);  % the estimate on
    [int2,evals] = IntAdapt(func,b,c,epsilon/2,evals,fb,fe,fc);  % both subintervals.
    int=int1+int2;
end
end % function IntAdapt.m