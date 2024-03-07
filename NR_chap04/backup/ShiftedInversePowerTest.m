% script RR_ShiftedInversePowerTest
% Test RR_ShiftedInversePower.m on a random matrix with known eigenvalues.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

clear; n=4; lambda=randn(n,1), Lambda=diag(lambda); S=rand(n); A=S*Lambda*inv(S)
[Snew]=RR_ShiftedInversePower(A,lambda);  eig_error=norm(A*Snew-Snew*Lambda)
[Unew,Tnew]=RR_ShiftedInversePower(A,lambda);  schur_error=norm(A-Unew*Tnew*Unew')

% end script RR_ShiftedInversePowerTest
