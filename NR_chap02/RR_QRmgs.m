function [A,R,pi,r] = QRmgs(A,s)
% function [A,R,pi,r] = QRmgs(A,s)
% Compute an ordered complete QR decomposition A*Pi=Q*R, and rank, of ANY mxn matrix A via
% Modified Gram-Schmidt (Q is returned in the modified A).  Pivoting is implemented, but
% note that, if s is specified, pivoting is not applied to the first s columns of A.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

[m,n]=size(A);  R=zeros(n,n);  pi=[1:n]'; tol=1e-8; if nargin==1, s=0; end
for i=1:n
  clear L; for j=i:n, L(j)=norm(A(:,j)); end; [LL,k]=max(L);       % Pivoting
  if LL>L(i) & i>s, R(:,[i k])=R(:,[k i]); A(:,[i k])=A(:,[k i]); pi([i k])=pi([k i]); end
  R(i,i)=LL;                     A(:,i)=A(:,i)/R(i,i);             % Modified Gram-Schmidt
  R(i,i+1:n)=A(:,i)'*A(:,i+1:n); A(:,i+1:n)=A(:,i+1:n)-(A(:,i))*(R(i,i+1:n));
end
r=n; for i=1:n, if abs(R(i,i))<tol, r=i-1; break, end, end, A=A(:,1:r); R=R(1:r,:);
if r<m, A(:,r+1:m)=randn(m,m-r); R(r+1:m,:)=zeros(m-r,n); A=RC_QRcgs(A,r); end
end % function QRmgs
