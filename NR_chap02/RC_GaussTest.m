% script RC_GaussTest
% Test RC_Gauss and RC_GaussLU on a random matrix.
% Note that this test script is NOT efficient, and is meant for TESTING PURPOSES ONLY.
% Any production code leveraging the RC_Gauss and RC_GaussLU codes should not save the
% modified A matrix in a new storage location (rather, it should simply overwrite A);
% also, a production code need not extract L and U out separately - note that the
% RC_GaussLU code solves Ly=b for y, then Ux=y for x, referencing the nontrivial elements
% of L and U as they sit in the modified A matrix.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_GaussPPTest, RC_GaussCPTest, RC_GaussEchelonTest.

disp('Now testing RC_Gauss & RC_GaussLU on a random matrix.')
n=5; m=2;  % note: m is the number of RHS vectors
A=randn(n);

% Note! RC_Gauss.m usually works fine on randomly-generated full matrices, but will fail
% if it encounters a zero pivot.  Uncomment the following line to see it fail.
% A(1,1)=0;

B=randn(n,m); [X,Amod]=RC_Gauss(A,B,n);
A_times_X_from_RC_Gauss=A*X, B, error=norm(A*X-B)

Bnew=randn(n,m); [Xnew]=RC_GaussLU(Amod,Bnew,n);
A_times_Xnew_from_RC_GaussLU=A*Xnew, Bnew, error=norm(A*Xnew-Bnew)

L=eye(n);   for i=2:n, for j=1:i-1, L(i,j)=-Amod(i,j); end, end
U=zeros(n); for i=1:n, for j=i:n,   U(i,j)= Amod(i,j); end, end
L, U, error=norm(A-L*U), disp(' ')

% end script RC_GaussTest
