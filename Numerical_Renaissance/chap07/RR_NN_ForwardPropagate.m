function [x]=RR_NN_ForwardPropagate(y,w,h,n)
% function [x]=RR_NN_ForwardPropagate(y,w,h,n)
% Given the input y and the weights w of a neural network with h hidden layers and n(k)
% nodes per layer, compute the state x of the entire network, including the output x{h+2}.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 
% See also RR_NN_BackPropagate, RR_NN_ComputeCost, RR_NN_SequentialTrain.  Trial: RR_NN_Test.

x{1}=y; for k=2:h+2, for i=1:n(k), x{k}(i,1)=tanh(w{k-1}(i,:)*x{k-1}(:)); end, end
end % function RR_NN_ForwardPropagate
