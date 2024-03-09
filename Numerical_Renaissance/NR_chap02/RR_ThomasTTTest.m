% script <a href="matlab:RR_ThomasTTTest">RR_ThomasTTTest</a>
% Test <a href="matlab:help RR_ThomasTT">RR_ThomasTT</a> on a random tridiagonal Toeplitz matrix.
% Note that this test script is NOT efficient, and is meant for TESTING PURPOSES ONLY.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap02
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 
% See also RR_ThomasTest, RR_CirculantTest, RR_ThomasParallelTest.

disp('Now testing RR_ThomasTT on a random tridiagonal Toeplitz matrix.')
n=5; m=2;  % note that m is the number of RHS vectors
a=randn; b=randn; c=randn; G=randn(n,m);
A=a*diag(ones(n-1,1),-1)+b*diag(ones(n,1),0)+c*diag(ones(n-1,1),1);
[X]=RR_ThomasTT(a,b,c,G,n); A_times_X_from_RR_ThomasTT=A*X, G, error=norm(A*X-G), disp(' ')

% end script RR_ThomasTTTest
