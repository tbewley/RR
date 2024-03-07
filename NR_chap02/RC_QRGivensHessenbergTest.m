% script <a href="matlab:RC_QRGivensHessenbergTest">RC_QRGivensHessenbergTest</a>
% Test <a href="matlab:help RC_QRGivensHessenberg">RC_QRGivensHessenberg</a> on a random (rectangular) RC_Hessenberg matrix.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

disp('Now testing RC_QRGivensHessenberg on a random (rectangular) RC_Hessenberg matrix.')
clear; m=5; n=4; A=randn(m,n)+i*randn(m,n);
for j=1:n-1, for i=j+2:m, A(i,j)=0; end, end, A  % forced matrix to be upper RC_Hessenberg
[R,Q]=RC_QRGivensHessenberg(A), nonorthogonality=norm(Q'*Q-eye(m)), residual=norm(Q*R-A)
disp(' ')

% end script RC_QRGivensHessenbergTest
