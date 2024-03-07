function [g] = RC_NN_BackPropagate(d,u,g)               % Numerical Renaissance Codebase 1.0
global x xin xout dm km n
x{km}(:)=x{km}(:)-xout(:,d);
for k=km-1:-1:1
  x{k+1}(:)=x{k+1}(:).*(sech(u{k}(:,:)*x{k}(:))).^2;
  whos
  for i=1:n(k), g{k}(:,i)=x{k+1}(:)*(x{k}(i))'; x{k}(i,1)=(x{k+1}(:))'*(u{k}(:,i)); end
end
end % function RC_NN_BackPropagate
