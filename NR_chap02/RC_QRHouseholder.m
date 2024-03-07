function [A,Q,pi,r] = QRHouseholder(A)
% function [A,Q,pi,r] = QRHouseholder(A)
% Compute a (full) QR decomposition A=Q*R of ANY mxn matrix A using a sequence of
% Householder reflections (R is returned in the modified A).  IF pi and r are
% requested, then pivoting is implemented and the decomposition is ordered, A*Pi=Q*R.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% Depends on <a href="matlab:help ReflectCompute">ReflectCompute</a>, <a href="matlab:help Reflect">Reflect</a>.

[m,n]=size(A); pi=[1:n]'; tol=1e-8; Q=eye(m,m);
for i=1:min(n,m-1)
  if nargout>2, for j=i:n, length(j)=norm(A(i:end,j)); end; [amax,imax]=max(length);
    if amax>length(i),  A(:,[i imax])=A(:,[imax i]);  pi([i imax])=pi([imax i]);  end
  clear length, end  
  [sig,w]=ReflectCompute(A(i:m,i)); A=Reflect(A,sig,w,i,m,i,n,'L');
  Q=Reflect(Q,sig,w,i,m,1,m,'R');
end
if nargout>2, r=min(m,n); for i=1:r, if abs(A(i,i))<tol, r=i-1; break, end, end, end
end % function QRHouseholder
