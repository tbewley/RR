function [b] = RC_EigHermitianImplicit(A,n,b,c)
% lam=RC_EigHermitian(A,n) computes the eigenvalues of a Hermitian (or symmetric) matrix A.
% Leveraging the fact that RC_Hessenberg.m returns a tridiagonal matrix, the QR algorithm
% with Wilkenson shifts is applied to the tridiagonal matrix T=tridiag[a,b,c] at each
% step.  Note that the tridiagonal matrix is deflated whenever b(n) converges.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

if nargin==2, A=RC_Hessenberg(A); a=[0; diag(A,-1)]; b=diag(A); c=[diag(A,1); 0];
else; a=A; end;
for step=1:20*n;                                  % Wilkenson shift
   t=(b(n-1)-b(n))/2.; mu=b(n)+t-sign(t)*sqrt(abs(t)^2+abs(a(n))^2); f=b(1)-mu; g=a(2); t=0;
   for i=1:n-1;
     fs=real(conj(f)*f); gs=real(conj(g)*g);
     if gs~=0,    
       if fs>=gs, cc=1/sqrt(1+gs/fs); ss=-cc*g/f;
       else,      ss=1/sqrt(1+fs/gs); cc=-ss*f/g;  end
       if i>1,  a(i) =       conj(cc)*a(i)-conj(ss)*t; end;
       [b(i), a(i+1)]=assign(conj(cc)*b(i)-conj(ss)*a(i+1),ss*b(i)+cc*a(i+1));
       [c(i), b(i+1)]=assign(conj(cc)*c(i)-conj(ss)*b(i+1),ss*c(i)+cc*b(i+1));
              c(i+1) =                                             cc*c(i+1);
       if i>1, c(i-1)  = conj(a(i)); end         
       [b(i),  c(i)]   = assign(cc*b(i)  -ss*c(i),  conj(ss)*b(i)  +conj(cc)*c(i));
       [a(i+1),b(i+1)] = assign(cc*a(i+1)-ss*b(i+1),conj(ss)*a(i+1)+conj(cc)*b(i+1));
       if i<n-1, [t,a(i+2)] = assign(    -ss*a(i+2),               +conj(cc)*a(i+2)); end
     end
     f=a(i+1); g=t;
   end
   if abs(a(n))< 1e-12*(abs(b(n))+abs(b(n-1)))                  % If b(n) converged,
     if n>2, b(1:n-1)=RC_EigHermitianImplicit(a(1:n-1),n-1,b(1:n-1),c(1:n-1)); end % deflate
     break
   end
end;  if step==20*n, disp('RC_EigHermitianImplicit did not converge'), else, b=real(b); end
end % function RC_EigHermitianImplicit.m

function [x,y]=assign(x,y)
end