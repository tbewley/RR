function X=RC_DALEtri(F,Q,n)                            % Numerical Renaissance Codebase 1.0
% This function finds the X that satisfies X = F^H X F + Q, where F is upper triangular
% and Q is full and Hermitian.
for i=1:n
  X(i,i)      = Q(i,i) / (1 - F(i,i)*conj(F(i,i)));
  X(i+1:n,i)  = (eye(n-i)-F(i,i)*F(i+1:n,i+1:n)') \ (Q(i+1:n,i)+F(i,i)*X(i,i)*F(i,i+1:n)');
  X(i,i+1:n)  = X(i+1:n,i)';
  Q(i+1:n,i+1:n) = Q(i+1:n,i+1:n) + X(i,i)*F(i,i+1:n)'*F(i,i+1:n) + ...
     + F(i,i+1:n)'*(F(i+1:n,i+1:n)'*X(i+1:n,i))' + (F(i+1:n,i+1:n)'*X(i+1:n,i))*F(i,i+1:n);
end
end % function RC_DALEtri.m