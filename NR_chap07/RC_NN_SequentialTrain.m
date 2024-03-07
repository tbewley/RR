function [w]=RC_NN_SequentialTrain(alpha,max_iters,y,u,N,w,h,n)
% function [w]=RC_NN_SequentialTrain(alpha,max_iters,y,u,N,w,h,n)
% Cycle through each training record k one at a time, and perform a fixed-coefficient step
% in the downhill direction a small amount at each iteration based on g{k} = d J_k / d w.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_NN_BackPropagate, RC_NN_ForwardPropagate, RC_NN_ComputeCost.  Verify with RC_NN_Test.

Jsave(1)=RC_NN_ComputeCost(y,u,N,w,h,n);
for iter=1:max_iters
  for d=1:N
    x=RC_NN_ForwardPropagate(y(:,d),w,h,n); g=RC_NN_BackPropagate(x{h+2}(:)-u(:,d),x,w,h,n);
    for k=1:h+1, w{k}=w{k}-alpha*g{k}; end
  end
  Jsave(iter+1)=RC_NN_ComputeCost(y,u,N,w,h,n); plot(Jsave); pause(0.001)
end
end % function RC_NN_SequentialTrain
