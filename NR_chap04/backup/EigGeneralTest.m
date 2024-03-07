% script RC_EigGeneralTest
% Test RC_EigGeneral, together with RC_ShiftedInversePower, on a random matrix.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

clear; n=10; A=randn(n)+sqrt(-1)*randn(n);  lam=RC_EigGeneral(A)
[S]=RC_ShiftedInversePower(A,lam);    eig_error=norm(A*S-S*diag(lam))
[U,T]=RC_ShiftedInversePower(A,lam);  schur_error=norm(A-U*T*U')

% end script RC_EigGeneralTest
