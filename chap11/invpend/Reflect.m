function [X,sig,w] = Reflect(X)                      % Numerical Renaissance Codebase 1.0
% Apply a Householder reflector matrix H^H to a MxN matrix X (i.e., calculate H^H*X),
% with [sigma,w] arranged to give zeros in the (2:end,1) locations of the result. 
x=X(:,1);  if real(x(1))<0, s=-1; else, s=1; end,  nu=s*norm(x);             % Eqn (1.12b)
if nu==0, sig=0; w=0; else, sig=(x(1)+nu)/nu; w=[x(1)+nu; x(2:end)]/(x(1)+nu); end
X(1,1)=-nu; X(2:end,1)=0;                                                    % Eqn (1.13)
X(:,2:end)=X(:,2:end)-(conj(sig)*w)*(w'*X(:,2:end));                         % Eqn (1.14a)
end % function Reflect.m
