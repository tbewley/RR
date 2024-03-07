% script QRHouseholderTest
% Test QRHouseholder.m on a random system.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

clear; m=5; n=4; A=randn(m,n)+i*randn(m,n); A(:,3)=A(:,1);

[R_unordered,Q]=QRHouseholder(A)  % The diagonal elements of R are unordered in this case.
nonorthogonality=norm(Q'*Q-eye(m)), residual=norm(Q*R_unordered-A), pause
 
[R_ordered,Q,pi,r]=QRHouseholder(A) % The diagonal elements of R are ordered in this case.
Pi=zeros(n); for i=1:n, Pi(pi(i),i)=1; end
nonorthogonality=norm(Q'*Q-eye(m)), residual=norm(Q*R_ordered-A*Pi)

% end script QRHouseholderTest
