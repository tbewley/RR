function [lam] = RC_EigGeneral(A)
% function [lam] = RC_EigGeneral(A)
% Computes the eigenvalues of a general complex matrix A. After an
% initial RC_Hessenberg decomposition, several explicitly shifted QR steps are taken.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

A=RC_Hessenberg(A); n=size(A,1); q=n; tol=1e-12;
while q>1        % Note: diagonal of T_22 block extends from {p,p} to {q,q} elements of T.
  for i=1:n-1; if abs(A(i+1,i))< tol*(abs(A(i,i))+abs(A(i+1,i+1))); A(i+1,i)=0; end; end
  q=1; for i=n-1:-1:1; if A(i+1,i)~=0, q=i+1; break, end, end, if q==1, continue, end                                                     
  p=1; for i=q-1:-1:1; if A(i+1,i)==0, p=i+1; break, end, end
  d=ones(n,1); mu=A(q,q);           % Initialize d and compute shift (lower-right corner).
  for i=p:q; A(i,i)=A(i,i)-mu; end  % Shift A.
  for i=p:q-1                       % Apply same algorithm as in RC_QRFastGivensHessenberg.
    [a(i),b(i),gamma(i),dn(i),d([i i+1])]=FastGivensCompute(A(i,i),A(i+1,i),d(i),d(i+1));
    [A]=FastGivens(A,a(i),b(i),gamma(i),dn(i),i,i+1,i,q,'L');
  end
  for i=p:q-1           % Apply the postmultiplications directly to A (thus computing R*Q).
    [A]=FastGivens(A,a(i),b(i),gamma(i),dn(i),i,i+1,p,q,'R');
  end                                                            
  for i=p:q, dt=1/sqrt(d(i)); A(i,max(i-1,1):end)=A(i,max(i-1,1):end)*dt;     % Scale A.
             A(1:min(i+1,n),i)  =A(1:min(i+1,n),i)*dt;  A(i,i)=A(i,i)+mu; end % Unshift A.
end, lam=diag(A);                   % Extract eigenvalues from main diagonal of result.
end % function RC_EigGeneral
