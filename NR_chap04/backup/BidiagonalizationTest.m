% script BidiagonalizationTest
% Test Bidiagonalization on a random complex matrix.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

clear; m=8; n=9; A=randn(m,n)+sqrt(-1)*randn(m,n); 
[B,U,V]=Bidiagonalization(A,m,n), error=norm(A-U*B*V')

% end script BidiagonalizationTest
