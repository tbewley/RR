function X=RC_CALEtri(A,Q,n)                            % Numerical Renaissance Codebase 1.0
% This function finds the X that satisfies A' X + X A + Q = 0, where A is upper triangular
% and Q is full and Hermitian.
for i=1:n
  X(i,i)         = -Q(i,i) / (A(i,i)+conj(A(i,i)));
  X(i+1:n,i)     = (A(i+1:n,i+1:n)'+A(i,i)*eye(n-i)) \ (-Q(i+1:n,i)-X(i,i)*A(i,i+1:n)');
  X(i,i+1:n)     = X(i+1:n,i)';
  Q(i+1:n,i+1:n) = Q(i+1:n,i+1:n) + A(i,i+1:n)'*X(i+1:n,i)' + X(i+1:n,i)*A(i,i+1:n);
end
end % function RC_CALEtri.m