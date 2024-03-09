% script RR_EigGeneralTest
% Test RR_EigGeneral, together with RR_ShiftedInversePower, on a random matrix.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

clear; n=10; A=randn(n)+sqrt(-1)*randn(n);  lam=RR_EigGeneral(A)
[S]=RR_ShiftedInversePower(A,lam);    eig_error=norm(A*S-S*diag(lam))
[U,T]=RR_ShiftedInversePower(A,lam);  schur_error=norm(A-U*T*U')

% end script RR_EigGeneralTest
