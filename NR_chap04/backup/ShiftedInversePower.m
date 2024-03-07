function [S,T] = RC_ShiftedInversePower(A,mu)
% function [S,T] = RC_ShiftedInversePower(A,mu)
% Apply two steps of the shifted inverse power method (per eigenvalue mu_k) to determine
% (if called with nargout=1) the eigenvectors S(:,k), OR (if called with nargout=2)
% the RC_Schur vectors U(:,k) and upper-triangular T of the RC_Schur decomposition A=U*T*U'.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

n=size(A,1);
for k=1:length(mu);
  B=A-mu(k)*eye(n);                                % Compute B=PLU (see RC_GaussPP.m) 
  for j = 1:n-1,                                   % Loop through each column j<n
    [amax,imax]=max(abs(B(j:n,j)));                % If necessary, exchange the rows of B.
    if amax>abs(B(j,j)); B([j j-1+imax],:)=B([j-1+imax j],:); end
    B(j+1:n,j)     = - B(j+1:n,j) / B(j,j);                        % Compute m_ij.
    B(j+1:n,j+1:n) = B(j+1:n,j+1:n) + B(j+1:n,j) * B(j,j+1:n);     % Outer product update.
  end
  if B(n,n)==0,              % RC_Eigenvalue exact! Solve Bs=0 exactly for a solution.
    S(n,k)=1;
    for i = n-1:-1:1,   S(i,k) = -B(i,i+1:n)*S(i+1:n,k) / B(i,i); end  % Backsubstitution.
  else                       % RC_Eigenvalue approximate. Apply Shifted Inverse Power method.
    S(:,k)=ones(n,1);        % Initialize (see footnote 8). (no need to apply P to e!)
    S(n,k)=S(n,k) / B(n,n);  % Solve Ux=e (see RC_GaussPP.m)
    for i = n-1:-1:1,   S(i,k) = (S(i,k)-B(i,i+1:n)*S(i+1:n,k)) / B(i,i); end
    for steps=1:2            % Then apply two steps of the shifted inverse power method.
      for j = 1:n-1, S(j+1:n,k) = S(j+1:n,k) + B(j+1:n,j) * S(j,k); end
      S(n,k) = S(n,k) / B(n,n);
      for i = n-1:-1:1, S(i,k) = (S(i,k)-B(i,i+1:n)*S(i+1:n,k)) / B(i,i); end
    end
  end
  if nargout>1; S(:,k) = S(:,k)-S(:,1:k-1)*S(:,1:k-1)'*S(:,k); end;  % Orthogonalize.
  S(:,k)=S(:,k)/norm(S(:,k));   % Note above that the RC_Schur decomposition may be derived
end                             % from this method simply by orthogonalization of the S
if nargout>1; T=S'*A*S; end;    % matrix and recomputation of T.
end % function RC_ShiftedInversePower

