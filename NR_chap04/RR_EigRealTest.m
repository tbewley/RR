% script <a href="matlab:RR_EigRealTest">RR_EigRealTest</a>
% Test <a href="matlab:help RR_EigReal">RR_EigReal</a>, together with <a href="matlab:help RR_ShiftedInversePower">RR_ShiftedInversePower</a>, on a random matrix.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.4.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

disp('Now testing RR_EigReal, together with RR_ShiftedInversePower, on a random matrix.')
clear; n=20; A=randn(n); lam=RR_EigReal(A)
[S]=RR_ShiftedInversePower(A,lam);    eig_error=norm(A*S-S*diag(lam))
[U,T]=RR_ShiftedInversePower(A,lam);  schur_error=norm(A-U*T*U'), disp(' ')

% end script RR_EigRealTest
