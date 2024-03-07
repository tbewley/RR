function TestNN                                      % Numerical Renaissance Codebase 1.0
global x xin xout dm km n
% inputs=256; outputs=36; km=4; n(1)=inputs; n(2)=300; n(3)=150; n(4)=outputs; dm=200;
inputs=3; outputs=2;  km=4; n(1)=inputs;  n(2)=15;  n(3)=5;  n(4)=outputs;  dm=5;
xin=randn(inputs,dm); xout=0.1*randn(outputs,dm)
small=10^(-1);  for k=1:km-1;  u{k}=small*randn(n(k+1),n(k));  end
figure(1); alpha=1; iterm=100;  [u]=SequentialTrainNN(alpha,iterm,u);
figure(2); alpha=2; iterm=1000; [u]=SequentialTrainNN(alpha,iterm,u);
end % function TestNN