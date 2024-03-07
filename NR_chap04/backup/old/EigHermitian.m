function [lam] = RC_EigHermitian(A)
% function [lam] = RC_EigHermitian(A)
% Compute the eigenvalues of a Hermitian (or, if real, symmetric) matrix A.
% Leveraging the fact that RC_Hessenberg.m returns a tridiagonal matrix, the QR algorithm
% with Wilkenson shifts is applied to the tridiagonal matrix T=tridiag[a,b,c] at each step.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

A=RC_Hessenberg(A); n=size(A,1); q=n; tol=1e-13;    % Note: we move the 3 nonzero diagonals to
a=[0; diag(A,-1)]; b=diag(A); c=[diag(A,1); 0];  % vectors to speeed the memory access.
while q>1        % Note: diagonal of T_22 block extends from {p,p} to {q,q} elements of T.
  for i=1:n-1; if abs(a(i+1))< tol*(abs(b(i))+abs(b(i+1))); a(i+1)=0; end; end
  q=1; for i=n-1:-1:1; if a(i+1)~=0, q=i+1; break, end, end, if q==1, continue, end                                                     
  p=1; for i=q-1:-1:1; if a(i+1)==0, p=i+1; break, end, end
  t=(b(n-1)-b(n))/2.; mu=b(n)+t-sign(t)*sqrt(abs(t)^2 + abs(a(n))^2);    % Wilkenson shift
  b=b-mu; [b,c,a,cc,ss]=QRGivensTridiag(a,b,c);      % Shift and calculate QR using Givens
  % Now calculate R*Q, given the n-1 values of [cc,ss] comprising each rotation
  % (rather than Q itself) and the nonzero diagonals [b,c,a] of the (uppertriangular) R.
  for i=1:n-1; if cc(i)~=0     
    if i>1, c(i-1)=cc(i)*c(i-1)-ss(i)      *a(i-1); end         % Eqn (1.15b), column i.
    temp   =       cc(i)*b(i)  -ss(i)      *c(i);              
    c(i)   = conj(ss(i))*b(i)  +conj(cc(i))*c(i);               % Eqn (1.15b), column i+1.
    b(i+1) =                    conj(cc(i))*b(i+1); b(i)=temp; 
  end, end  
  a(2:n)=conj(c(1:n-1)); b=b+mu;                                % Unshift A.
end, lam=real(b);               % Remove any error in the complex part of the eigenvalues.
end % function RC_EigHermitian
