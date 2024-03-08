% script RR_GaussPPTest
% Test RR_GaussPP and RR_GaussPLU on a random matrix.
% This test script is NOT efficient, and is meant for TESTING PURPOSES ONLY.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap02
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 
% See also InvTest, RR_GaussTest, RR_GaussCPTest, RR_GaussEchelonTest.

disp('Now testing RR_GaussPP & RR_GaussPLU on a random matrix.')
n=5; m=2; % note that m is the number of RHS vectors
A=randn(n); A(1,1)=0;  % Note: RR_Gauss.m would fail on this matrix!  [See RR_GaussTest.m...]
B=randn(n,m); [X,Amod,p]=RR_GaussPP(A,B,n);
A_times_X_from_RR_GaussPP=A*X, B, error=norm(A*X-B)

Bnew=randn(n,m); [Xnew]=RR_GaussPLU(Amod,Bnew,p,n);
A_times_Xnew_from_RR_GaussPLU=A*Xnew, Bnew, error=norm(A*Xnew-Bnew)

P=zeros(n); for k=1:n, P(p(k),k)=1; end
L=eye(n);   for i=2:n, for j=1:i-1, L(i,j)=-Amod(i,j); end, end
U=zeros(n); for i=1:n, for j=i:n,   U(i,j)= Amod(i,j); end, end
P, L, U, error=norm(A-P*L*U), disp(' ')

% end script RR_GaussPPTest
