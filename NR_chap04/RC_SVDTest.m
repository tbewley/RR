% script <a href="matlab:SVDTest">RC_SVDTest</a>
% Test SVD on a random complex matrix.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

disp('Now testing SVD on a random complex matrix.')
clear; m=5; n=6; A=randn(m,n)+sqrt(-1)*randn(m,n);
A(3,:)=A(4,:); [U,S,V,r]=SVD(A), error=norm(A-U*S*V'), disp(' ')

% end script SVDTest
