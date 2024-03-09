% script <a href="matlab:RR_ShiftedInversePowerTest">RR_ShiftedInversePowerTest</a>
% Test <a href="matlab:help RR_ShiftedInversePower">RR_ShiftedInversePower</a> on a matrix with known eigenvalues.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.4.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

disp('Now testing RR_ShiftedInversePower on a matrix with known eigenvalues.')
clear; n=4; lambda=randn(n,1), Lambda=diag(lambda); S=rand(n); A=S*Lambda*inv(S)
[Snew]=RR_ShiftedInversePower(A,lambda);  eig_error=norm(A*Snew-Snew*Lambda)
[Unew,Tnew]=RR_ShiftedInversePower(A,lambda);  schur_error=norm(A-Unew*Tnew*Unew'), disp(' ')

% end script RR_ShiftedInversePowerTest
