% script <a href="matlab:RC_NN_Test">RC_NN_Test</a>
% Test the convergence of the neural network algorithm based on some random training data.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_NN_BackPropagate, RC_NN_ComputeCost, RC_NN_ForwardPropagate, RC_NN_SequentialTrain.

clear, in=60; out=1; h=2;
n(1)=in; n(2)=100; n(3)=20; n(4)=out; for k=1:h+1; w{k}=10^(-1)*randn(n(k+1),n(k)); end
N=200; y=rand(in,N); u=rand(out,N); [w]=RC_NN_SequentialTrain(0.1,99,y,u,N,w,h,n);
% end script RC_NN_Test
