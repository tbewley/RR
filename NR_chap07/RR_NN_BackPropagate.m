function [g]=RC_NN_BackPropagate(e,x,w,h,n)               
% function [g]=RC_NN_BackPropagate(e,x,w,h,n)
% Compute the gradient g with respect to the weights w based on the output error e=u-v in
% a neural network with state x (computed using RC_NN_ForwardPropagate).
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_NN_ForwardPropagate, RC_NN_ComputeCost, RC_NN_SequentialTrain.  Verify with RC_NN_Test.

x{h+2}(:)=e; for k=h+1:-1:1
  x{k+1}(:)=x{k+1}(:).*(sech(w{k}(:,:)*x{k}(:))).^2;
  for i=1:n(k), g{k}(:,i)=x{k+1}(:)*x{k}(i); end          % Compute g{k} = d J_k / d w
  if k>1, for i=1:n(k), x{k}(i,1)=(x{k+1}(:))'*(w{k}(:,i)); end, end
end
end % function RC_NN_BackPropagate
