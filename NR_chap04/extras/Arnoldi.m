function [A] = RC_Arnoldi(A,n,p)                        % Numerical Renaissance Codebase 1.0
% This routine implements the Implictly Restarted RC_Arnoldi Method to find the n leading
% eigenvectors of the nonsymmetric matrix A.
Q(:,1)=randn(n,1); kmin=1; L=zeros(n,n);
for iter=1:itmax
  for k=kmin:n+p
    Q(:,k+1)=A*Q(:,k)  % The only place where A is used. (Replace with function call!)
    L(k,1:k)=Q(:,k+1)'*Q(:,1:k); Q(:,k+1)=Q(:,k+1)-(Q(:,1:k))*(L(k,1:k))'; % Orthogonalize
    L(k,k+1)=norm(Q(:,k+1));     Q(:,k+1)=Q(:,k+1)/L(k,k+1);               % Normalize
  end
  % We now have A*Q=Q*L+[0 ... 0 Q(:,n+p+1)]*L(n+p,n+p+1), where Q is unitary and L is
  % lower RC_Hessenberg.  Now apply p steps of shifted QR to L, accumulating the effects on Q.
  % These QR steps contaminate only the last p columns of L, which we subsequently discard.
  % The first n columns of L retains their RC_Hessenberg structure, eventually converging to a
  % lower triangular form as the routine iterates, thus approaching the first n columns of
  % a lower RC_Schur decomposition A=Q*L*Q^H.
  % Note that L(n+p,n+p+1) reflects the error in this representation.



  kmin=N;
end

% end function RC_Arnoldi.m