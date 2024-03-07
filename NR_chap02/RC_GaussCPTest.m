% script <a href="matlab:RC_GaussCPTest">RC_GaussCPTest</a>
% Test <a href="matlab:help RC_GaussCP">RC_GaussCP</a> and <a href="matlab:help RC_GaussPLUQT">RC_GaussPLUQT</a> on a random matrix.
% This test script is NOT efficient, and is meant for TESTING PURPOSES ONLY.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_GaussTest, RC_GaussPPTest, RC_GaussEchelonTest.

disp('Now testing RC_GaussCP & RC_GaussPLUQT on a random matrix.')
n=5; m=2; % note that m is the number of RHS vectors
A=randn(n); A(1,1)=0;  % Note: RC_Gauss.m would fail on this matrix!  [See RC_GaussTest.m...]
B=randn(n,m); [X,Amod,p,q]=RC_GaussCP(A,B,n);
A_times_X_from_RC_GaussCP=A*X, B, error=norm(A*X-B)

Bnew=randn(n,m); [Xnew]=RC_GaussPLUQT(Amod,Bnew,p,q,n);
A_times_Xnew_from_RC_GaussPLUQT=A*Xnew, Bnew, error=norm(A*Xnew-Bnew)

P=zeros(n); for k=1:n, P(p(k),k)=1; end
Q=zeros(n); for k=1:n, Q(q(k),k)=1; end
L=eye(n);   for i=2:n, for j=1:i-1, L(i,j)=-Amod(i,j); end, end
U=zeros(n); for i=1:n, for j=i:n,   U(i,j)= Amod(i,j); end, end
P, L, U, Q, error=norm(A-P*L*U*Q'), disp(' ')

% end script RC_GaussCPTest
