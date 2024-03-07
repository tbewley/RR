% script <a href="matlab:RC_ThomasTTTest">RC_ThomasTTTest</a>
% Test <a href="matlab:help RC_ThomasTT">RC_ThomasTT</a> on a random tridiagonal Toeplitz matrix.
% Note that this test script is NOT efficient, and is meant for TESTING PURPOSES ONLY.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_ThomasTest, RC_CirculantTest, RC_ThomasParallelTest.

disp('Now testing RC_ThomasTT on a random tridiagonal Toeplitz matrix.')
n=5; m=2;  % note that m is the number of RHS vectors
a=randn; b=randn; c=randn; G=randn(n,m);
A=a*diag(ones(n-1,1),-1)+b*diag(ones(n,1),0)+c*diag(ones(n-1,1),1);
[X]=RC_ThomasTT(a,b,c,G,n); A_times_X_from_RC_ThomasTT=A*X, G, error=norm(A*X-G), disp(' ')

% end script RC_ThomasTTTest
