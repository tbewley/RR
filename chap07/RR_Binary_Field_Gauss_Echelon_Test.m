% script RR_Binary_Field_Gauss_Echelon_Test
% Test RR_Binary_Field_Gauss_Echelon on a binary matrix with m=4, n=5, and r=3.
% Renaissance Robotics codebase, Chapter 7, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under BSD 3-Clause License.

disp('Now testing RR_Binary_Field_Gauss_Echelon on a matrix with m=4, n=5, and r=3.')
A=[1  0  0  0  0  1;  0 0 1 1 1 1; 0 0 0 0 1 1;  0 1 1 1 1 1; 0 0 0 1 0 1]
[m,n]=size(A);  [Amod,p,r,v,R] = RR_Binary_Field_Gauss_Echelon(A);

% The nontrivial part of L is in the column below each pivot in the modified A
L=eye(m);      for j=1:r,  for i=j+1:m,    L(i,j)=Amod(i,v(j));  end,  end

% The nontrivial part of U, in echelon form (determined according to r and v), is
% contained in the corresponding entries of the modified A.
U=zeros(m,n);  for i=1:r,  for j=v(i):n,   U(i,j)=Amod(i,j);      end,  end

% p(k) is the row of the nonzero entry in the k'th column of P
P=zeros(m);    for k=1:m   P(p(k),k)=1;  end

P, L, U, R, rank=r, error=norm(mod(A-P*L*U,2)), disp(' ')
