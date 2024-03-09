% script QRcgsTest
% Test QRcgs.m on a random system.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

clear; m=5; n=4; A=randn(m,n)+i*randn(m,n);  % Try tall or square (m>=n), real or complex A.
A, [Q,R]=QRcgs(A), nonorthogonality=norm(Q'*Q-eye(n)), residual=norm(Q*R-A)

% end script QRcgsTest
