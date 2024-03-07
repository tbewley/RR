% script RC_QRFastGivensHessenbergTest
% Test RC_QRFastGivensHessenberg on a random system.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

disp('Now initializing a random complex RC_Hessenberg matrix');
clear; m=5; n=4; A=randn(m,n)+i*randn(m,n);
for j=1:n-1, for i=j+2:m, A(i,j)=0; end, end, A
disp('Now testing RC_QRFastGivensHessenberg');
[R,Q]=RC_QRFastGivensHessenberg(A), nonorthogonality=norm(Q'*Q-eye(m)), residual=norm(Q*R-A)

% end script RC_QRFastGivensHessenbergTest
