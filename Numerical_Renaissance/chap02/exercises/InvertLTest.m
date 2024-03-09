% script InvertLTest
% Test InvertL.m on a random lower-triangular matrix.
% Numerical Renaissance Codebase 1.0, NRchap2; see text for copyleft info.

clear, format short, format compact, n=5;
for i=1:n, for j=1:i, L(i,j)=randn; end, end, L

Linv=InvertL(L,n)
error=norm(eye(n)-L*Linv)

% end script InvertLTest
