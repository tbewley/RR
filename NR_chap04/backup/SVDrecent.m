function [A,U,V] = SVD(A,m,n,U,V)
% [S,U,V]=SVD(A,m,n) computes the reduced SVD of a full rank mxn matrix A for m>=n.
% (For m<n case, use this algorithm to compute the reduced SVD of A^H, then swap U and V.)
if nargin==3, [A,U,V]=Bidiagonalization(A,m,n); p=1; q=n;  % Bidiagonal B=U^H A V
else p=m, q=n, end;
tol=1e-11;
for step=1:10*n;      
   if abs(A(q-1,q))< 1e-10*(abs(A(q-1,q-1))+abs(A(q,q)))   % If A(q-1,q) converged,
     if q>2, [A,U,V] = SVD(A,q-1,q-1,U,V); end                 % deflate
     break
   end


                               % Compute Wilkenson shift of T=B^H B
   dq=A(q,q); dm=A(q-1,q-1); fm=A(q-1,n); d1=A(1,1); f1=A(1,2);
   bq=real(dq)^2+imag(dq)^2+real(fm)^2+imag(fm)^2; aq=(dm)*conj(fm);
   if q>2 fl=A(q-2,q-1); bm=real(dm)^2+imag(dm)^2+real(fl)^2+imag(fl)^2;
   else                  bm=real(dm)^2+imag(dm)^2; end
   t=real(bm-bq)/2.; mu=bq+t-sign(t)*sqrt(conj(t)*t+conj(aq)*aq); % Compute first rotation
   f=real(d1)^2+imag(d1)^2-mu; g=d1*conj(f1);                     % using this shift.
   for i=1:q-1;                                      % Then apply implicit Q to return to 
     [A,c,s]=Rotate (f,g,i,i+1,'post',A);            % matrix to upper bidiagonal form.
     [V]    =Rotate2(c,s,i,i+1,'post',V);
     f=A(i,i); g=A(i+1,i);
     [A,c,s]=Rotate (f,g,i,i+1,'pre ',A);
     [U]    =Rotate2(c,s,i,i+1,'post',U);
     if i<q-1, f=A(i,i+1); g=A(i,i+2); end
   end
   
   
   if abs(A(q,q))<tol                                % zero last column and deflate
     for i=q-1:-1:1;  [A,c,s] = Rotate (A(i,i),A(i,q),i,q,'post',A);  
                      [V]     = Rotate2(c,s,i,q,'post',V);           end
	 [A,U,V] = SVD(A,1,q-1,U,V);  A, pause;	 break
   end
   for k=q-1:-1:1; if abs(A(k,k))<tol
     for k=k+1:q;  [A,c,s]=Rotate (f,g,i,i+1,'pre ',A);
                   [U]    =Rotate2(c,s,i,i+1,'post',U);
     end
   end, end
end;
if step==20*n, disp('SVD did not converge'), else,
  if nargin==3;
    [scratch,index]=sort(-abs(diag(A)));  s=diag(A); U=U(:,1:n); j=sqrt(-1);
	if isreal(s); for i=1:n; if s(i)<0; U(:,i)=-U(:,i); end; end            % Make s(i)>0.
	else          for i=1:n; U(:,i)=U(:,i)*exp(j*atan2(imag(s(i)),real(s(i)))); end; end
	A=diag(abs(s(index))); U=U(:,index); V=V(:,index);                      % Sort s,U,V
    for r=n:-1:1; if abs(A(r,r))>tol; break; end, end, r
	U=U(:,1:r); A=A(1:r,1:r); V=V(:,1:r);
  end
end
end % function SVD.m