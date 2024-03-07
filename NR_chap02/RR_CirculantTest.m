% script <a href="matlab:RC_CirculantTest">RC_CirculantTest</a>
% Test <a href="matlab:help RC_Circulant">RC_Circulant</a> and <a href="matlab:help RC_CirculantLU">RC_CirculantLU</a> on a random circulant matrix.
% Note that this test script is NOT efficient, and is meant for TESTING PURPOSES ONLY.
% Any production code leveraging the RC_Circulant.m and RC_CirculantLU.m codes should not
% actually build the (sparse) A, L, and U matrices.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_ThomasTest, RC_ThomasTTTest, RC_ThomasParallelTest.

disp('Now testing RC_Circulant & RC_CirculantLU on a random circulant matrix.')
n=6; m=1;  % note that m is the number of RHS vectors
a=randn(n,1); b=randn(n,1); c=randn(n,1); G=randn(n,m);
A=diag(a(2:n),-1)+diag(b(1:n),0)+diag(c(1:n-1),1); A(1,n)=a(1); A(n,1)=c(n);
[X,amod,bmod,cmod,dmod,emod]=RC_Circulant(a,b,c,G,n);
disp('Now testing RC_Circulant'), A, A*X, G, error=norm(A*X-G)

Gnew=randn(n,m);
[Xnew]=RC_CirculantLU(amod,bmod,cmod,dmod,emod,Gnew,n);
disp('Now testing RC_CirculantLU'), A*Xnew, Gnew, error=norm(A*Xnew-Gnew)

L=eye(n);   for i=2:n, L(i,i-1)=-amod(i); end
U=zeros(n); for i=1:n, U(i,i)=bmod(i);  end, for i=1:n-1, U(i,i+1)=cmod(i); end
L(n,1:n-2)=-emod(1:n-2);  U(1:n-1,n)=dmod(1:n-1);
disp('Now checking the LU decomposition'), L, U, error=norm(A-L*U), disp(' ')

% end script RC_CirculantTest
