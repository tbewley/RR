% script RC_EigTest
% Test RC_Eig.m on a random matrices of various structure.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

clear; n=10; A_gen=randn(n)+sqrt(-1)*randn(n);  [lam_gen,S_gen]=RC_Eig(A_gen,'g');
eig_general_error=norm(A_gen*S_gen-S_gen*diag(lam_gen))

clear; n=20; A=randn(n)+sqrt(-1)*randn(n); A_her=A*A'; [lam_her,S_her]=RC_Eig(A_her,'h');
eig_hermitian_error=norm(A_her*S_her-S_her*diag(lam_her))

clear; n=20; A_real=randn(n); [lam_real,S_real]=RC_Eig(A_real,'r');
eig_real_error=norm(A_real*S_real-S_real*diag(lam_real))

% end script RC_EigTest
