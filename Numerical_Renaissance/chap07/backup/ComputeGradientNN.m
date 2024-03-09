function [g] = ComputeGradientNN(u)                  % Numerical Renaissance Codebase 1.0
global x xin xout dm km n
g=u*0; for d=1:dm; x=ForwardPropogateNN(d,u); g=BackPropogateNN(d,u,g); end
end % function ComputeGradientNN