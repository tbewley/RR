function [J] = RC_NN_ComputeCost(u)                     % Numerical Renaissance Codebase 1.0
global x xin xout dm km n
J=0; for d=1:dm; NN_ForwardPropogate(d,u); J=J+0.5*(x{km}-xout(:,d))'*(x{km}-xout(:,d)); end
end % function RC_NN_ComputeCost