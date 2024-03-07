function [A,R] = QRcgs(A,s)
% function [A,R] = QRcgs(A,s)
% Compute a reduced QR decomposition A=Q*R of an mxn matrix A via Classical Gram-Schmidt.
% Pivoting is NOT implemented; redundant columns of A are simply set to zero.
% If s is specified, the first s columns are skipped (assumed to already be orthogonal).
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

[m,n]=size(A);  R=eye(n,n); if nargin==1, s=0; end
for i=s+1:n
  R(1:i-1,i)=A(:,1:i-1)'*A(:,i);       A(:,i)=A(:,i)-A(:,1:i-1)*R(1:i-1,i);
  R(i,i)=norm(A(:,i)); if R(i,i)>1e-9, A(:,i)=A(:,i)/R(i,i); else, A(:,i)=zeros(m,1); end
end                                    % Note: Q is returned in the modified A.
end % function QRcgs
