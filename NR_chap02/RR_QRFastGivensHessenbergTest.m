% script <a href="matlab:RC_QRFastGivensHessenbergTest">RC_QRFastGivensHessenbergTest</a>
% Test <a href="matlab:help RC_QRFastGivensHessenberg">RC_QRFastGivensHessenberg</a> on a random complex RC_Hessenberg matrix.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

disp('Now testing RC_QRFastGivensHessenberg on a random complex RC_Hessenberg matrix.')
clear; m=5; n=4; A=randn(m,n)+i*randn(m,n);
for j=1:n-1, for i=j+2:m, A(i,j)=0; end, end, A
[R,Q]=RC_QRFastGivensHessenberg(A), nonorthogonality=norm(Q'*Q-eye(m)), residual=norm(Q*R-A)
disp(' ')

% end script RC_QRFastGivensHessenbergTest
