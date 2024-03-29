% script <a href="matlab:InvTest">RR_InvTest</a>
% Test <a href="matlab:help Inv">Inv</a> on a random matrix.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap02
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 
% See also RR_GaussPPTest.

disp('Now testing Inv on a random matrix.')
n=5; A=randn(n); A(1,1)=0; A, Ainv=Inv(A), error=norm(A*Ainv-eye(n)), disp(' ')

% end script RR_InvTest
