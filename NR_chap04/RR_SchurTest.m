% script <a href="matlab:RC_SchurTest">RC_SchurTest</a>
% Test <a href="matlab:help RC_Schur">RC_Schur</a> on random matrices of various structure.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.4.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

disp('Now testing RC_Schur on random matrices of various structure.')
clear; n=10; A_gen=randn(n)+sqrt(-1)*randn(n);  [U_gen,T_gen]=RC_Schur(A_gen,'g');
schur_general_error=norm(A_gen-U_gen*T_gen*U_gen')

clear; n=20; A=randn(n)+sqrt(-1)*randn(n); A_her=A*A'; [U_her,T_her]=RC_Schur(A_her,'h');
schur_hermitian_error=norm(A_her-U_her*T_her*U_her')

clear; n=20; A_real=randn(n); [U_real,T_real]=RC_Schur(A_real,'r');
schur_real_error=norm(A_real-U_real*T_real*U_real'), disp(' ')

% end script RC_SchurTest
