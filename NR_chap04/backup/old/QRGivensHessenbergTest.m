% script RR_QRGivensHessenbergTest
% Test RR_QRGivensHessenberg.m on a random system.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

disp('Now initializing a random complex RR_Hessenberg matrix');
clear; m=5; n=4; A=randn(m,n)+i*randn(m,n);
for j=1:n-1, for i=j+2:m, A(i,j)=0; end, end, A  % forced to be upper RR_Hessenberg.
disp('Now testing RR_QRGivensHessenberg');
[R,Q]=RR_QRGivensHessenberg(A), nonorthogonality=norm(Q'*Q-eye(m)), residual=norm(Q*R-A)

% end script RR_QRGivensHessenbergTest
