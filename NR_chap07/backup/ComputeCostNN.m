function [J] = ComputeCostNN(u)                      % Numerical Renaissance Codebase 1.0
global x xin xout dm km n
J=0; for d=1:dm; ForwardPropogateNN(d,u); J=J+0.5*(x{km}-xout(:,d))'*(x{km}-xout(:,d)); end
end % function ComputeCostNN