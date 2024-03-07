% script RR_EigRealTest
% Test RR_EigReal, together with RR_ShiftedInversePower, on a random matrix.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

clear; n=20; A=randn(n); lam=RR_EigReal(A)
[S]=RR_ShiftedInversePower(A,lam);    eig_error=norm(A*S-S*diag(lam))
[U,T]=RR_ShiftedInversePower(A,lam);  schur_error=norm(A-U*T*U')

% end script RR_EigRealTest
