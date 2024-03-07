function [U,S,V,r] = RC_SVD(A,type)
% function [U,S,V,r] = RC_SVD(A,type)
% Compute the rank and reduced (by default) or complete (if type='complete') SVD of A.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.4.7.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Depends on <a href="matlab:help RotateCompute">RotateCompute</a>, <a href="matlab:help Rotate">Rotate</a>.

[m,n]=size(A); if m<n, [V,S,U,r]=RC_SVD(A'); else
tol=1e-15; p=1; q=n; [A,U,V]=RC_Bidiagonalization(A,m,n);
while q>1           % Note: diagonal of B_22 block extends from {p,p} to {q,q} elements.
  if abs(A(q,q))<tol;                             % If necessary, zero out last column...
    for i=q-1:-1:1; 
     [c,s]=RC_rotate_compute(conj(A(i,i)),conj(A(i,q)));
     [A]=RC_rotate(A,c,s,i,q,max(i-1,1),i,'R'); [V]=RC_rotate(V,c,s,i,q,1,n,'R');
    end
  end                  
  for k=q-1:-1:p, if abs(A(k,k))<tol, A(k,k)=0;   % ...or zero out an intermediate row.
    for j=k+1:q,    
     [c,s]=RC_rotate_compute(A(j,j),A(k,j));
     [A]=RC_rotate(A,c,s,j,k,j,min(j+1,q),'L'); [U]=RC_rotate(U,c,s,j,k,1,m,'R');
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
    [c,s]=RC_rotate_compute(f,g);                      % B_22 matrix to upperbidiagonal form.                          
    [A]=RC_rotate(A,c,s,i,i+1,max(p,i-1),i+1,'R'); [V]=RC_rotate(V,c,s,i,i+1,1,n,'R');                          
    f=A(i,i); g=A(i+1,i);                               
    [c,s]=RC_rotate_compute(f,g);
    [A]=RC_rotate(A,c,s,i,i+1,i,min(i+2,q),'L');   [U]=RC_rotate(U,c,s,i,i+1,1,m,'R');
    if i<q-1, f=conj(A(i,i+1)); g=conj(A(i,i+2)); end
  end
end
s=diag(A); [scratch,index]=sort(-abs(s)); j=sqrt(-1);
if isreal(s), for i=1:n, if s(i)<0, V(:,i)=-V(:,i); end, end      % Rotate to make s(i)>0.
else,         for i=1:n, U(:,i)=U(:,i)*exp(j*atan2(imag(s(i)),real(s(i)))); end, end
s=abs(s); for r=n:-1:1, if s(index(r))>1e-7, break, end, end     % Compute rank.
if isreal(A), U=real(U); V=real(V); end
if (nargin==2 & type=='complete'), S=diag(s);
else, S=diag(s(index(1:r))); U=U(:,index(1:r)); V=V(:,index(1:r)); end % Arrange S,U,V.
end % function SVD
