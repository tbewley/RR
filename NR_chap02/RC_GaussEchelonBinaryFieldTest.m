% script <a href="matlab:RC_GaussEchelonTest">RC_GaussEchelonBinaryFieldTest</a>
% Test <a href="matlab:help RC_GaussEchelon">RC_GaussEchelon</a> on a matrix with m=4, n=5, and r=3.
% Note that this test script is NOT efficient, and is meant for TESTING PURPOSES ONLY.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_GaussPPTest.

disp('Now testing RC_GaussEchelonBinaryFieldTest on a matrix with m=4, n=5, and r=3.')
A=[ 0  0  3  9  3;  -1 -2  2  0  5;  2  4 -1 -3  5;  1  2  1 -3 10]  % See (2.12)
[m,n]=size(A);  [Amod,p,r,v,R] = RC_GaussEchelon(A);

% The nontrivial part of L is in the column below each pivot in the modified A
L=eye(m);      for j=1:r,  for i=j+1:m,    L(i,j)=-Amod(i,v(j));  end,  end

% The nontrivial part of U, in echelon form (determined according to r and v), is
% contained in the corresponding entries of the modified A.
U=zeros(m,n);  for i=1:r,  for j=v(i):n,   U(i,j)=Amod(i,j);      end,  end

% p(k) is the row of the nonzero entry in the k'th column of P
P=zeros(m);    for k=1:m   P(p(k),k)=1;  end

P, L, U, R, rank=r, error=norm(A-P*L*U), disp(' ')

% end script RC_GaussEchelonTest
