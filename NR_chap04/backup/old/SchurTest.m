% script RC_SchurTest
% Test RC_Schur.m on a random matrices of various structure.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

clear; n=10; A_gen=randn(n)+sqrt(-1)*randn(n);  [U_gen,T_gen]=RC_Schur(A_gen,'g');
schur_general_error=norm(A_gen-U_gen*T_gen*U_gen')

clear; n=20; A=randn(n)+sqrt(-1)*randn(n); A_her=A*A'; [U_her,T_her]=RC_Schur(A_her,'h');
schur_hermitian_error=norm(A_her-U_her*T_her*U_her')

clear; n=20; A_real=randn(n); [U_real,T_real]=RC_Schur(A_real,'r');
schur_real_error=norm(A_real-U_real*T_real*U_real')

% end script RC_SchurTest
