% script <a href="matlab:RC_EigGeneralTest">RC_EigGeneralTest</a>
% Test <a href="matlab:help RC_EigGeneral">RC_EigGeneral</a>, together with <a href="matlab:help RC_ShiftedInversePower">RC_ShiftedInversePower</a>, on a random matrix.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.4.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

disp('Now testing RC_EigGeneral, together with RC_ShiftedInversePower, on a random matrix.')
clear; n=10; A=randn(n)+sqrt(-1)*randn(n);  lam=RC_EigGeneral(A)
[S]=RC_ShiftedInversePower(A,lam);    eig_error=norm(A*S-S*diag(lam))
[U,T]=RC_ShiftedInversePower(A,lam);  schur_error=norm(A-U*T*U')
disp(' ')
                                                    
% end script RC_EigGeneralTest
