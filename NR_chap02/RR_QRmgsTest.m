% script QRmgsTest
% Test QRmgs on a random matrix.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap02
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 

disp('Now testing QRmgs on a random matrix')
clear; m=5; n=4; A=randn(m,n)+i*randn(m,n); % Try tall or square (m>=n), real or complex A.
A(:,3)=A(:,1);    % Note: the unpivoted QRcgs algorithm would fail on this singular matrix!
A, [Q,R,pi,r]=RR_QRmgs(A)             % Note that the diagonal elements of R come out ordered.
Pi=zeros(n); for i=1:n, Pi(pi(i),i)=1; end
nonorthogonality=norm(Q'*Q-eye(r)), residual=norm(Q*R-A*Pi), disp(' ')

% end script QRmgsTest
