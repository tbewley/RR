function X=RC_CALE(A,Q)
% function X=RC_CALE(A,Q)
% Compute the X that satisfies A X + X A' + Q = 0 for full A and Hermitian Q.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

n=size(A,1); [U,T]=RC_Schur(A'); A0=T'; Q0=U'*Q*U; X0=RC_CALEtri(A0,Q0,n); X=U*X0*U'; 
end % function RC_CALE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X=RC_CALEtri(A,Q,n)
% Compute the X that satisfies A X + X A' + Q = 0 for lower-triangular A and Hermitian Q.
for i=1:n
  X(i,i)     = -Q(i,i) / (A(i,i)+A(i,i)');
  X(i+1:n,i) = RC_GaussPP(A(i+1:n,i+1:n)+A(i,i)'*eye(n-i),-Q(i+1:n,i)-X(i,i)*A(i+1:n,i),n-i);
  X(i,i+1:n) = X(i+1:n,i)';
  Q(i+1:n,i+1:n) = Q(i+1:n,i+1:n) + A(i+1:n,i)*X(i+1:n,i)' + X(i+1:n,i)*A(i+1:n,i)';
end
end % function RC_CALEtri
