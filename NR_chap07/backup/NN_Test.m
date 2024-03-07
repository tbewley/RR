function RC_NN_Test                                     % Numerical Renaissance Codebase 1.0
global x xin xout dm km n
inputs=60; outputs=1;  km=4; n(1)=inputs;  n(2)=100;  n(3)=20;  n(4)=outputs;  dm=200;
xin=rand(inputs,dm); xout=rand(outputs,dm)
small=10^(-1);  for k=1:km-1;  u{k}=small*randn(n(k+1),n(k));  end
figure(1); alpha=1; iterm=100;  [u]=RC_NN_SequentialTrain(alpha,iterm,u);
figure(2); alpha=2; iterm=1000; [u]=RC_NN_SequentialTrain(alpha,iterm,u);
end % function RC_NN_Test