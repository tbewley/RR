% script QRmgsTest
% Test QRmgs on a random system.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

clear; m=5; n=4; A=randn(m,n)+i*randn(m,n); % Try tall or square (m>=n), real or complex A.
A(:,3)=A(:,1);    % Note: the unpivoted QRcgs algorithm would fail on this singular matrix!
A, [Q,R,pi,r]=QRmgs(A)             % Note that the diagonal elements of R come out ordered.
Pi=zeros(n); for i=1:n, Pi(pi(i),i)=1; end
nonorthogonality=norm(Q'*Q-eye(r)), residual=norm(Q*R-A*Pi)

% end script QRmgsTest
