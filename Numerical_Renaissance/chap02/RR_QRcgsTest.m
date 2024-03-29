% script <a href="matlab:QRcgsTest">QRcgsTest</a>
% Test <a href="matlab:help QRcgs">QRcgs</a> on a random matrix.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap02
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 

disp('Now testing QRcgs on a random matrix')
clear, m=5; n=4; A=randn(m,n)+i*randn(m,n)  % Try tall or square (m>=n), real or complex A.
[Q,R]=QRcgs(A), nonorthogonality=norm(Q'*Q-eye(n)), residual=norm(Q*R-A), disp(' ')

% end script QRcgsTest
