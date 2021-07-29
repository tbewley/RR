function [] = RR_BCH_Constructor(m,t)
% function [A,p,r,v,R] = RR_Gauss_Echelon_Binary_Field(A)
% This function computes the A=P*L*U decomposition, on GF(2^m), of a singular or nonsquare matrix A,
% where P is a permutation matrix, L is unit lower triangular, and U is in echelon form,
% using an extension of Gaussian elimination with partial pivoting (see NR, Chapter 2), and
% with all arithmetic restricted to the binary Galois field GF(2^m).
% The computation is done essentially in place in the matrix A.
% INPUT:  A=a possibly singular or nonsquare matrix with binary elements
% OUTPUT: A=the matrix A is replaced by the m_ij (which can be used to build L) and U on exit
%         p=the permutation vector
%         v=a vector containing the column of each pivot.
% EXAMPLE CALL: see RR_Gauss_Echelon_Binary_Field_Test
% Renaissance Robotics codebase, Chapter 7, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under BSD 3-Clause License.

% First, define the minimum primitive polynomial f(z) for this m (with 1<=m<=50)
P=[ 1  0  0  0  0;  2  1  0  0  0;  3  1  0  0  0;  4  1  0  0  0;  5  2  0  0  0; ...
    6  1  0  0  0;  7  1  0  0  0;  8  4  3  2  0;  9  4  0  0  0; 10  3  0  0  0; ... 
   11  2  0  0  0; 12  6  4  1  0; 13  4  3  1  0; 14  5  3  1  0; 15  1  0  0  0; ...
   16  5  3  2  0; 17  3  0  0  0; 18  7  0  0  0; 19  6  5  1  0; 20  3  0  0  0; ... 
   21  2  0  0  0; 22  1  0  0  0; 23  5  0  0  0; 24  4  3  1  0; 25  3  0  0  0; ...
   26  8  7  1  0; 27  8  7  1  0; 28  3  0  0  0; 29  2  0  0  0; 30 16 15  1  0; ... 
   31  3  0  0  0; 32 28 27  1  0; 33 13  0  0  0; 34 15 14  1  0; 35  2  0  0  0; ...
   36 11  0  0  0; 37 12 10  2  0; 38  6  5  1  0; 39  4  0  0  0; 40 21 19  2  0; ... 
   41  3  0  0  0; 42 23 22  1  0; 43  6  5  1  0; 44 27 26  1  0; 45  4  3  1  0; ...
   46 21 20  1  0; 47  5  0  0  0; 48 28 27  1  0; 49  9  0  0  0; 50 27 26  1  0];
f=0b0u64; for i=1:5, f=bitset(f,P(m,i)+1); end, dec2bin(f)

for p=3:2:2*t-1  % Now, calculate the minimum polynomials for beta_p=alpha^p with p=3,5,7,...
  for i=0:m
     b(i)=0b0u64; b(i)=bitset(b,p*i); b=RR_Binary_Field_Mod(b,f);
  end
 
  % build A matrix row by row here

  % Convert A to reduced echelon form R
  % [Amod,p,r,v,R] = RR_Gauss_Echelon_Binary_Field(A);
  
  % Extract minimum nontrivial solution to determfine phi_p()
end

% LCM of product of f with the various rows of phi.
