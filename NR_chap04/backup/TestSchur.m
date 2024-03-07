% script RC_TestSchur
% Test the RC_Schur decomposition codes 
% Remove various semicolons to print stuff to screen along the way, or leave the
% semicolons in and change N to try larger matrices.

disp('Now initializing a random complex square NxN matrix');
N=4;
A=randn(4)+i*randn(4);
disp('Now testing RC_SchurGeneral, and comparing with the Matlab eig routine');
[T,U]=RC_SchurGeneral(A); U*T*U'-A, diag(T), eig(A)
lambda=RC_SchurGeneral(A), eig(A)

% end script RC_TestSchur.m
