function [J]=RC_NN_ComputeCost(y,u,N,w,h,n)
% function [J]=RC_NN_ComputeCost(y,u,N,w,h,n)
% Compute the mean-square error over the training set used to train a neural network.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_NN_BackPropagate, RC_NN_ForwardPropagate, RC_NN_SequentialTrain.  Verify with RC_NN_Test.

J=0; for d=1:N;
  x=RC_NN_ForwardPropagate(y(:,d),w,h,n); J=J+(0.5/N)*norm(x{h+2}-u(:,d));
end
end % function RC_NN_ComputeCost
