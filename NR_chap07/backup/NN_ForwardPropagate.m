function NN_ForwardPropogate(d,u)                    % Numerical Renaissance Codebase 1.0
global x xin xout dm km n
x{1}=xin(:,d); for k=2:km, for i=1:n(k), x{k}(i,1)=tanh(u{k-1}(i,:)*x{k-1}(:)); end, end
end % function NN_ForwardPropogate