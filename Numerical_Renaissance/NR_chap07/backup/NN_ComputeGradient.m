function [g] = NN_ComputeGradient(u)                 % Numerical Renaissance Codebase 1.0
global x xin xout dm km n
g=u*0; for d=1:dm; x=NN_ForwardPropogate(d,u); g=NN_BackPropogate(d,u,g); end
end % function NN_ComputeGradient