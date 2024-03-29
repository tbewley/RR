% script <a href="matlab:RR_MatrixExponentialTest">RR_MatrixExponentialTest</a>
% Compare <a href="matlab:help RR_MatrixExponential">RR_MatrixExponential</a> to the result obtained via the eigen decomposition.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.2.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear; n=4; A=randn(n), t=randn(1)^2, Phi=RR_MatrixExponential(A,t)
[lam,S]=RR_Eig(A,'r'); Phi_via_RR_Eig=real(S*diag(exp(lam*t))*Inv(S)), disp(' ')

disp('Next <a href="matlab:help RCchap20">RCchap20</a> demo: <a href="matlab:RR_SS2TFTest">RR_SS2TFTest</a>'), disp(' ')
% end script RR_MatrixExponentialTest
