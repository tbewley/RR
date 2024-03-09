function [A,R] = QRcgs(A)
% function [A,R] = QRcgs(A)
% Compute a reduced QR decomposition A=Q*R of an mxn matrix A via Classical Gram-Schmidt.
% Pivoting is NOT implemented, so A must have full column rank (ie, m>=n and rank(A)=n).
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

[m,n]=size(A);  R=zeros(n,n);      %  Note: Q is returned in the modified A.
for i=1:n
   R(1:i-1,i)=A(:,1:i-1)'*A(:,i);  A(:,i)=A(:,i)-A(:,1:i-1)*R(1:i-1,i);
   R(i,i)=norm(A(:,i));            A(:,i)=A(:,i)/R(i,i);
end
end % function QRcgs
