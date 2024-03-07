% script <a href="matlab:RR_QRFastGivensHessenbergTest">RR_QRFastGivensHessenbergTest</a>
% Test <a href="matlab:help RR_QRFastGivensHessenberg">RR_QRFastGivensHessenberg</a> on a random complex RR_Hessenberg matrix.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

disp('Now testing RR_QRFastGivensHessenberg on a random complex RR_Hessenberg matrix.')
clear; m=5; n=4; A=randn(m,n)+i*randn(m,n);
for j=1:n-1, for i=j+2:m, A(i,j)=0; end, end, A
[R,Q]=RR_QRFastGivensHessenberg(A), nonorthogonality=norm(Q'*Q-eye(m)), residual=norm(Q*R-A)
disp(' ')

% end script RR_QRFastGivensHessenbergTest
