function [g] = NN_ComputeGradient(u)
% function [g]=NN_ComputeGradient(d,u,g)
% ??? 
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 7.5.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap07">Chapter 7</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_NN_BackPropagate, RC_NN_ComputeCost, RC_NN_ForwardPropagate, RC_NN_SequentialTrain.
% Verify with RC_NN_Test.

global x xin xout dm km n
g=u*0; for d=1:dm; x=RC_NN_ForwardPropagate(d,u); g=g+NN_BackPropogate(d,u,g); end
end % function NN_ComputeGradient
