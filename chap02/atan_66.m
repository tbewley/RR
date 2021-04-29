% atan_66.m 
% from the Renaissance Robotics codebase, by Thomas Bewley

function [out]=atan_66(x)
if     x<0, out=-atan_66(-x);
elseif 1<x, out=pi/2-atan_66(1/x);
elseif x>tan(pi/12),
    pi_over_6=pi/6; c=tan(pi_over_6); 
    out=pi_over_6+atan_66((x-c)/(1+c*x));
else
    c1=1.6867629106; c2=0.4378497304; c3=1.6867633134;
    x2=x*x; out=x*(c1+x2*c2)/(c3+x2);
end
