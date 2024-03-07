% script <a href="matlab:InvTest">RC_InvTest</a>
% Test <a href="matlab:help Inv">Inv</a> on a random matrix.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_GaussPPTest.

disp('Now testing Inv on a random matrix.')
n=5; A=randn(n); A(1,1)=0; A, Ainv=Inv(A), error=norm(A*Ainv-eye(n)), disp(' ')

% end script RC_InvTest
