% script ReducedSVDTest
% Test the ReducedSVD routine on a random matrix.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

clear; m=6; n=5;
A=randn(m,n-1)+sqrt(-1)*randn(m,n-1);     % Create a random mxn matrix A
A(:,n)=A(:,1)+A(:,2); A                   % with linearly dependent last column.
[S,U,V,rank]=ReducedSVD(A)                % Compute reduced SVD.
SVD_error=norm(A-U*S*V')
U_nonorthogonality=norm(U'*U-eye(rank))
V_nonorthogonality=norm(U'*U-eye(rank))

% end script ReducedSVDTest