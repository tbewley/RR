function [J]=RR_NN_ComputeCost(y,u,N,w,h,n)
% function [J]=RR_NN_ComputeCost(y,u,N,w,h,n)
% Compute the mean-square error over the training set used to train a neural network.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RR_NN_BackPropagate, RR_NN_ForwardPropagate, RR_NN_SequentialTrain.  Verify with RR_NN_Test.

J=0; for d=1:N;
  x=RR_NN_ForwardPropagate(y(:,d),w,h,n); J=J+(0.5/N)*norm(x{h+2}-u(:,d));
end
end % function RR_NN_ComputeCost
