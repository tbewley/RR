% script <a href="matlab:CholeskyTest">CholeskyTest</a>
% Test <a href="matlab:help Cholesky">Cholesky</a> on a random positive-definite matrix.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.4.8.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

disp('Now testing Cholesky on a random positive-definite matrix.')
clear; n=5; format short; A=rand(n)+i*rand(n); A=A'*A; G=Cholesky(A,n), error=norm(A-G*G')
disp(' ')

% end script CholeskyTest
