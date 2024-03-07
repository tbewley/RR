function [b] = RC_EigHermitian(A,n,b,c)
% lam=RC_EigHermitian(A,n) computes the eigenvalues of a Hermitian (or symmetric) matrix A.
% Leveraging the fact that RC_Hessenberg.m returns a tridiagonal matrix, the QR algorithm
% with Wilkenson shifts is applied to the tridiagonal matrix T=tridiag[a,b,c] at each
% step.  Note that the tridiagonal matrix is deflated whenever b(n) converges.
if nargin==2, T=RC_Hessenberg(A); a=[0; diag(T,-1)]; b=diag(T); c=[diag(T,1); 0];
else; a=A; end;
for step=1:20*n;                                  % Wilkenson shift
   t=(b(n-1)-b(n))/2.; mu=b(n)+t-sign(t)*sqrt(abs(t)^2 + abs(a(n))^2); b=b-mu;
   [b,c,a,cc,ss]=QRGivensTridiagonal(a,b,c);      % Shift and calculate QR using Givens
   % Now calculate R*Q, given the n-1 values of [cc,ss] comprising each rotation
   % (rather than Q itself) and the nonzero diagonals [b,c,a] of the (uppertriangular) R.
   for i=1:n-1; if cc(i)~=0     
     if i>1, c(i-1)=cc(i)*c(i-1)-ss(i)      *a(i-1); end         % Eqn (1.15b), column i
     temp   =       cc(i)*b(i)  -ss(i)      *c(i);              
     c(i)   = conj(ss(i))*b(i)  +conj(cc(i))*c(i);               % Eqn (1.15b), column i+1
     b(i+1) =                    conj(cc(i))*b(i+1); b(i)=temp; 
   end, end  
   a(2:n)=conj(c(1:n-1)); b=b+mu;
   if abs(a(n))< 1e-12*(abs(b(n))+abs(b(n-1)))                   % If b(n) converged,
     if n>2, b(1:n-1)=RC_EigHermitian(a(1:n-1),n-1,b(1:n-1),c(1:n-1)); end % deflate
     break
   end
end;  if step==20*n, disp('RC_EigHermitian did not converge'), else, b=real(b); end
end % function RC_EigHermitian.m
