% script <a href="matlab:RC_BidiagonalizationTest">BidiagonalizationTest</a>
% Test <a href="matlab:help Bidiagonalization">Bidiagonalization</a> on a random complex matrix.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.4.7.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

disp('Now testing Bidiagonalization on a random complex matrix.')
m=8; n=9; A=randn(m,n)+sqrt(-1)*randn(m,n); 
[B,U,V]=RC_Bidiagonalization(A,m,n), error=norm(A-U*B*V'), disp(' ')

% end script RC_Bidiagonalization
