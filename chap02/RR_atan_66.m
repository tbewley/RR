function [out]=RR_atan_66(x)
% function [out]=RR_atan_66(x)
% INPUT:  any real x
% OUTPUT: atan(x), with about 6.6 digits of precision
% TEST:   x=randn, a=atan(x), b=RR_atan_66(x), residual=norm(a-b)
% Renaissance Robotics codebase, Chapter 1, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License.

if     x<0, out=-RR_atan_66(-x);
elseif 1<x, out=pi/2-RR_atan_66(1/x);     % Range reduction to 0<=x<=pi/12
elseif x>tan(pi/12),
    pi_over_6=pi/6; c=tan(pi_over_6); 
    out=pi_over_6+RR_atan_66((x-c)/(1+c*x));
else                           % Chebyshev series expansion from Hart (1978)
    c1=1.6867629106; c2=0.4378497304; c3=1.6867633134;
    x2=x*x; out=x*(c1+x2*c2)/(c3+x2);
end