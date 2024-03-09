function [A,R,pi,r] = QRmgs(A)                        
% function [A,R,pi,r] = QRmgs(A)
% Compute an ordered reduced QR decomposition A*Pi=Q*R, and rank, of ANY mxn matrix A via
% Modified Gram-Schmidt (Q is returned in the modified A).  Pivoting is implemented.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

[m,n]=size(A);  R=zeros(n,n);  pi=[1:n]'; tol=1e-14;
for i=1:n
  for j=i:n, length(j)=norm(A(:,j)); end; [amax,imax]=max(length); % Pivoting
  if amax > length(i)
    R(:,[i imax])=R(:,[imax i]); A(:,[i imax])=A(:,[imax i]); pi([i imax])=pi([imax i]);
  end, clear length
  R(i,i)=amax;                   A(:,i)=A(:,i)/R(i,i);             % Modified Gram-Schmidt
  R(i,i+1:n)=A(:,i)'*A(:,i+1:n); A(:,i+1:n)=A(:,i+1:n)-(A(:,i))*(R(i,i+1:n));
end
r=n; for i=1:n, if abs(R(i,i))<tol, r=i-1; break, end, end, A=A(:,1:r); R=R(1:r,:);
end % function QRmgs
