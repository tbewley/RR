function [v_bin,v_shorthand] = RR_BCH_Constructor(m,t)
% function [v_bin,v_shorthand] = RR_BCH_Constructor(m,t)
% This function computes the A=P*L*U decomposition, on GF(2^m), of a singular or nonsquare matrix A,
% where P is a permutation matrix, L is unit lower triangular, and U is in echelon form,
% using an extension of Gaussian elimination with partial pivoting (see NR, Chapter 2), and
% with all arithmetic restricted to the binary Galois field GF(2^m).
% The computation is done essentially in place in the matrix A.
% INPUT:  (m,t)=integers defining the BCH code
% OUTPUT: v_bin=character string of binary coefficients of v(z)
%         v_shorthand=
% EXAMPLE CALL: [v_bin,v_shorthand] = RR_BCH_Constructor(4,2)
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
f=0b0u64; for i=1:5, f=bitset(f,P(m,i)+1); end, phi(1)=f;
% f_bin=dec2bin(f)    % Uncomment to peek at f in binary form 

for p=3:2:2*t-1  % Calculate the required minimum polynomials for beta_p=alpha^p with p=3,5,7,...
  for q=0:m
     b=0b0u64; b=bitset(b,p*q+1); b=RR_Binary_Field_Mod(b,f);
     % build column i of binary mx(m+1) matrix A (each row from lsb to msb, as opposed to elsewhere)
     A(:,q+1)=bitget(b,1:m);
  end
  % Convert A to binary reduced echelon form R
  [A,t,r,v,R] = RR_Binary_Field_Gauss_Echelon(A);
  % Identify first nonpivot column (npc) of R
  npc=m+1; for i=1:length(v), if v(i)>i, npc=i; break, end, end
  % Extract minimum nontrivial solution to determfine phi_p(p)
  count=(p+1)/2; phi(count)=0b0u64; phi(count)=bitset(phi(count),npc);
  for i=1:npc-1, phi(count)=bitset(phi(count),i,R(i,npc)); end
  % p, phi_bin=dec2bin(phi(count))  % Uncomment to peek at phi_p in binary form 
end
% Compute LCM[f(z),phi_3(z),phi_5(z),...].
factors=unique(phi); v_dec=f;
for i=2:length(factors); v_dec=RR_Binary_Field_Prod(v_dec,factors(i)); end
v_bin=dec2bin(v_dec); v_shorthand=dec2hex(bitshift(v_dec,-1));
