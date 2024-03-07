function [u] = SequentialTrainNN(alpha,iterm,u)      % Numerical Renaissance Codebase 1.0
global x xin xout dm km n
Jsave(1,1)=ComputeCostNN(u);
for iter=1:iterm, for d=1:dm
  ForwardPropogateNN(d,u);  for k=1:km-1; g{k}=u{k}*0; end;  g=BackPropogateNN(d,u,g);
  for k=1:km-1; u{k}=u{k}-alpha*g{k}; end
end, Jsave(iter+1,1)=ComputeCostNN(u); end;  plot(Jsave)
end % function SequentialTrainNN
