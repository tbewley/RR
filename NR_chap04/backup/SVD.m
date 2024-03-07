function [S,U,V,r] = SVD(A)
% function [S,U,V,r] = SVD(A)
% Compute the reduced SVD and rank of any matrix A.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

[m,n]=size(A); if m<n, [S,V,U,r]=SVD(A'); else
tol=1e-15; p=1; q=n; [A,U,V]=Bidiagonalization(A,m,n);
while q>1           % Note: diagonal of B_22 block extends from {p,p} to {q,q} elements.
  if abs(A(q,q))<tol;                             % If necessary, zero out last column...
    for i=q-1:-1:1; 
     [c,s]=RotateCompute(conj(A(i,i)),conj(A(i,q)));
     [A]=Rotate(A,c,s,i,q,max(i-1,1),i,'R'); [V]=Rotate(V,c,s,i,q,1,n,'R');
    end
  end                  
  for k=q-1:-1:p, if abs(A(k,k))<tol, A(k,k)=0;   % ...or zero out an intermediate row.
    for j=k+1:q,    
     [c,s]=RotateCompute(A(j,j),A(k,j));
     [A]=Rotate(A,c,s,j,k,j,min(j+1,q),'L'); [U]=Rotate(U,c,s,j,k,1,m,'R');
    end
  end, end,                                                         % Compute p and q
  for i=1:n-1; if abs(A(i,i+1))< tol*(abs(A(i,i))+abs(A(i+1,i+1))); A(i,i+1)=0; end; end
  q=1; for i=n-1:-1:1; if A(i,i+1)~=0, q=i+1; break, end, end, if q==1, continue, end                                                     
  p=1; for i=q-1:-1:1; if A(i,i+1)==0, p=i+1; break, end, end
  dp=A(p,p); dm=A(q-1,q-1); dq=A(q,q); fp=A(p,p+1); fm=A(q-1,q);    % Wilkenson shift of
  bq=real(dq)^2+imag(dq)^2+real(fm)^2+imag(fm)^2; aq=(dm)*conj(fm); % T=B_{22}^H B_{22}.
  if q>2, fl=A(q-2,q-1); bm=real(dm)^2+imag(dm)^2+real(fl)^2+imag(fl)^2;
  else,                  bm=real(dm)^2+imag(dm)^2; end
  t=real(bm-bq)/2.; mu=bq+t-sign(t)*sqrt(t*t+conj(aq)*aq);     % Set up first rotation
  f=real(dp)^2+imag(dp)^2-mu; g=dp*conj(fp);                   % using this shift.
  for i=p:q-1                                      % Then apply implicit Q to return the
    [c,s]=RotateCompute(f,g);                      % B_22 matrix to upperbidiagonal form.                          
    [A]=Rotate(A,c,s,i,i+1,max(p,i-1),i+1,'R'); [V]=Rotate(V,c,s,i,i+1,1,n,'R');                          
    f=A(i,i); g=A(i+1,i);                               
    [c,s]=RotateCompute(f,g);
    [A]=Rotate(A,c,s,i,i+1,i,min(i+2,q),'L');   [U]=Rotate(U,c,s,i,i+1,1,m,'R');
    if i<q-1, f=conj(A(i,i+1)); g=conj(A(i,i+2)); end
  end
end
s=diag(A); [scratch,index]=sort(-abs(s)); j=sqrt(-1);
if isreal(s), for i=1:n, if s(i)<0, V(:,i)=-V(:,i); end, end      % Rotate to make s(i)>0.
else,         for i=1:n, U(:,i)=U(:,i)*exp(j*atan2(imag(s(i)),real(s(i)))); end, end
s=abs(s); for r=n:-1:1, if s(index(r))>1e-10, break, end, end     % Compute rank.
S=diag(s(index(1:r))); U=U(:,index(1:r)); V=V(:,index(1:r));      % Arrange S, U, V.
end
end % function SVD
