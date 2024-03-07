function [A] = RC_EigReal(A,n,flag)                     % Numerical Renaissance Codebase 1.0
% lam=RC_EigReal(A,n) computes the eigenvalues of a nonsymmetric real matrix A. After an
% initial RC_Hessenberg decomposition, several double implicitly-shifted QR steps are taken
% using the algorithm.  Note that T is deflated whenever T(m,m) converges.
if nargin==2, A=RC_Hessenberg(A); end;  kp=min(4,n);
if n==2
  a=(A(1,1)+A(2,2))/2; b=sqrt(4*A(1,2)*A(2,1)+(A(1,1)-A(2,2))^2)/2; A(1,1)=a+b; A(2,2)=a-b;
else,  for step=1:20*n            % If A(n,n) converged, deflate (via recursion)
  if abs(A(n,n-1))< 1e-12*(abs(A(n,n))+abs(A(n-1,n-1)))          
    if n>2, A(1:n-1,1:n-1)=RC_EigReal(A(1:n-1,1:n-1),n-1,1); end; break
  end                             % If A(n-1:n,n-1:n) converged, deflate (via recursion)
  if abs(A(n-1,n-2))< 1e-12*(abs(A(n,n))+abs(A(n-1,n-1))+abs(A(n,n-1))+abs(A(n-1,n)))   
    if n>3, A(1:n-2,1:n-2)=RC_EigReal(A(1:n-2,1:n-2),n-2,1); end;
    a=(A(n-1,n-1)+A(n,n))/2; b=sqrt(4*A(n-1,n)*A(n,n-1)+(A(n-1,n-1)-A(n,n))^2)/2;
    A(n-1,n-1)=a+b; A(n,n)=a-b; break % Put eigenvalues of A(n-1:n,n-1:n) on main diagonal.
  end
  c=A(n-1,n-1)+A(n,n);                                  % Trace of A(n-1:n,n-1:n)
  d=A(n-1,n-1)*A(n,n) - A(n-1,n)*A(n,n-1);              % Determinant of A(n-1:n,n-1:n)
  x(1,1)=A(1,1)*A(1,1) + A(1,2)*A(2,1) - c*A(1,1) + d;  % Compute first column of M.
  x(2,1)=A(2,1)*(A(1,1)+A(2,2)-c); x(3,1)=A(2,1)*A(3,2);      
  [x,sig,w]=Reflect(x);                                 % Compute V_0
  A(1:3,:)=A(1:3,:)-(conj(sig)*w)*(w'*A(1:3,:));        % Compute V_0 T V_0
  A(1:kp,1:3)=A(1:kp,1:3)-(A(1:kp,1:3)*w)*(sig*w');
  for k=1:n-2;  km=min(k+3,n); kn=min(k+4,n);           % Transform the rest of the matrix
    [A(k+1:km,k:n),sig,w]=Reflect(A(k+1:km,k:n));       % via Implicit Q, returning it to
    A(1:kn,k+1:km)=A(1:kn,k+1:km)-(A(1:kn,k+1:km)*w)*(sig*w');  % upper RC_Hessenberg form.
  end
end;  if step==20*n, disp('RC_EigReal did not converge'), end
if nargin==2, A=diag(A); end;     % Extract eigenvalues from main diagonal of result.
end % function RC_EigReal.m
