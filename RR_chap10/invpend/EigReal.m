function [A] = EigReal(A)                            % Numerical Renaissance Codebase 1.0
% lam=EigReal(A) computes the eigenvalues of a nonsymmetric real matrix A. After an
% initial Hessenberg decomposition, several double implicitly-shifted QR steps are taken.
A=Hessenberg(A); n=size(A,1); q=n; tol=1e-12;
while q>1        % Note: diagonal of T_22 block extends from {p,p} to {q,q} elements of T.
  for i=1:n-1; if abs(A(i+1,i))< tol*(abs(A(i,i))+abs(A(i+1,i+1))); A(i+1,i)=0; end; end
  q=1; for i=n-1:-1:1; if A(i+1,i)~=0, q=i+1; break, end, end, if q==1, continue, end                                                     
  p=1; for i=q-1:-1:1; if A(i+1,i)==0, p=i+1; break, end, end
  if q-p==1, a=(A(p,p)+A(q,q))/2; b=sqrt(4*A(p,q)*A(q,p)+(A(p,p)-A(q,q))^2)/2;
    A(p,p)=a+b; A(q,q)=a-b; A(q,p)=0;         % Put eigenvalues of A(q:p,q:p) on diagonal.
  continue, end 
  t=A(q-1,q-1)+A(q,q);                                     % Trace of A(q-1:q,q-1:q)
  d=A(q-1,q-1)*A(q,q) - A(q-1,q)*A(q,q-1);                 % Determinant of A(q-1:q,q-1:q)
  x(1,1)=A(p,p)*A(p,p) + A(p,p+1)*A(p+1,p) - t*A(p,p) + d; % Compute first column of M.
  x(2,1)=A(p+1,p)*(A(p,p)+A(p+1,p+1)-t);
  x(3,1)=A(p+1,p)*A(p+2,p+1);      
  [x,sig,w]=Reflect(x);                                              % Compute V_0
  A(p:p+2,:)=A(p:p+2,:)-(conj(sig)*w)*(w'*A(p:p+2,:)); r=min(p+3,q); % Compute V_0^H T
  A(p:r,p:p+2)=A(p:r,p:p+2)-(A(p:r,p:p+2)*w)*(sig*w');               % Compute V_0^H T V_0
  for k=p:q-2;  km=min(k+3,q); kn=min(k+4,q);            % Transform the rest of T_22
    [A(k+1:km,k:q),sig,w]=Reflect(A(k+1:km,k:q));        % via Implicit Q, returning it to
    A(p:kn,k+1:km)=A(p:kn,k+1:km)-(A(p:kn,k+1:km)*w)*(sig*w');    % upper Hessenberg form.
  end
end,  A=diag(A);                       % Extract eigenvalues from main diagonal of result.
end % function EigReal.m
