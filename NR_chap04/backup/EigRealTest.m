% script RC_EigRealTest
% Test RC_EigReal, together with RC_ShiftedInversePower, on a random matrix.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

clear; n=20; A=randn(n); lam=RC_EigReal(A)
[S]=RC_ShiftedInversePower(A,lam);    eig_error=norm(A*S-S*diag(lam))
[U,T]=RC_ShiftedInversePower(A,lam);  schur_error=norm(A-U*T*U')

% end script RC_EigRealTest
