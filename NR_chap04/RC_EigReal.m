function [lam] = RC_EigReal(A)                            
% function [lam] = RC_EigReal(A)                            
% Compute the eigenvalues of a nonsymmetric real matrix A. After an initial RC_Hessenberg
% decomposition, several double implicitly-shifted QR steps are taken, building up as much
% of the real RC_Schur decomposition as necessary in order to determine the eigenvalues.
% (That is, for efficiency, we do not build the full real RC_Schur decomposition, but rather
% work just on T_22 at each iteration). 
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.4.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

A=RC_Hessenberg(A); n=size(A,1); q=n; tol=1e-12;
while q>1        % Note: diagonal of T_22 block extends from {p,p} to {q,q} elements of T.
  for i=1:n-1; if abs(A(i+1,i))< tol*(abs(A(i,i))+abs(A(i+1,i+1))); A(i+1,i)=0; end; end
  q=1; for i=n-1:-1:1; if A(i+1,i)~=0, q=i+1; break, end, end, if q==1, continue, end                                                     
  p=1; for i=q-1:-1:1; if A(i+1,i)==0, p=i+1; break, end, end
  if q-p==1, a=(A(p,p)+A(q,q))/2; b=sqrt(4*A(p,q)*A(q,p)+(A(p,p)-A(q,q))^2)/2;
    A(p,p)=a+b; A(q,q)=a-b; A(q,p)=0;  % Put eigenvalues of A(q:p,q:p) on diagonal.
  continue, end 
  t=A(q-1,q-1)+A(q,q);                                     % Trace of A(q-1:q,q-1:q)
  d=A(q-1,q-1)*A(q,q) - A(q-1,q)*A(q,q-1);                 % Determinant of A(q-1:q,q-1:q)
  x(1,1)=A(p,p)*A(p,p) + A(p,p+1)*A(p+1,p) - t*A(p,p) + d; % Compute first column of M.
  x(2,1)=A(p+1,p)*(A(p,p)+A(p+1,p+1)-t);
  x(3,1)=A(p+1,p)*A(p+2,p+1);
  [sig,w]=RC_reflect_compute(x);                       % Compute V_0
  A=RC_reflect(A,sig,w,p,p+2,p,q,'L');                % Compute V_0^H T
  A=RC_reflect(A,sig,w,p,p+2,p,min(p+3,q),'R');       % Compute V_0^H T V_0
  for k=p:q-2;  km=min(k+3,q); kn=min(k+4,q);   % Transform the rest of T_22
    [sig,w]=RC_reflect_compute(A(k+1:km,k));        % via Implicit Q, returning it to                            
    A=RC_reflect(A,sig,w,k+1,km,k,q,'L');          % upper RC_Hessenberg form.
    A=RC_reflect(A,sig,w,k+1,km,p,min(k+4,q),'R');          
  end
end, lam=RC_EigSort(diag(A));   % Extract eigenvalues from main diagonal of result and sort.
end % function RC_EigReal
