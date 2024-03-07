% script <a href="matlab:RC_EigRealTest">RC_EigRealTest</a>
% Test <a href="matlab:help RC_EigReal">RC_EigReal</a>, together with <a href="matlab:help RC_ShiftedInversePower">RC_ShiftedInversePower</a>, on a random matrix.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.4.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

disp('Now testing RC_EigReal, together with RC_ShiftedInversePower, on a random matrix.')
clear; n=20; A=randn(n); lam=RC_EigReal(A)
[S]=RC_ShiftedInversePower(A,lam);    eig_error=norm(A*S-S*diag(lam))
[U,T]=RC_ShiftedInversePower(A,lam);  schur_error=norm(A-U*T*U'), disp(' ')

% end script RC_EigRealTest
