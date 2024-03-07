% script <a href="matlab: RC_EigTest">RC_EigTest</a>
% Test <a href="matlab:help RC_Eig">RC_Eig</a> on random matrices of various structure.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.4.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

disp('Now testing RC_Eig on random matrices of various structure.')
clear; n=10; A_gen=randn(n)+sqrt(-1)*randn(n);  [lam_gen,S_gen]=RC_Eig(A_gen,'g');
eig_general_error=norm(A_gen*S_gen-S_gen*diag(lam_gen))

clear; n=20; A=randn(n)+sqrt(-1)*randn(n); A_her=A*A'; [lam_her,S_her]=RC_Eig(A_her,'h');
eig_hermitian_error=norm(A_her*S_her-S_her*diag(lam_her))

clear; n=20; A_real=randn(n); [lam_real,S_real]=RC_Eig(A_real,'r');
eig_real_error=norm(A_real*S_real-S_real*diag(lam_real)), disp(' ')

% end script RC_EigTest
