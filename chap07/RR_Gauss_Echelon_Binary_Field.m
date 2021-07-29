function [A,p,r,v,R] = RR_Gauss_Echelon_Binary_Field(A)
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

[m,n]=size(A);  p=[1:m]';  r=0; v=[];             % Initialize rank = 0, no pivots
for j = 1:n,
   [amax,imax]=max(A(r+1:m,j));                   % Find the max element in left column
   if amax == 1                                   % If it is nonzero, increment the rank,
      r=r+1; v(r)=j;                              % store this pivot location, and,
      if r<m                                      % if not in the very last row, then
         if amax > A(r,j)                         % exchange rows if necessary ...
             A([r r-1+imax],:)=A([r-1+imax r],:);
             p([r r-1+imax])  =p([r-1+imax r]); 
         end                                      % then perform the Gauss transformation.
         A(r+1:m,j+1:n) = mod(A(r+1:m,j+1:n) + A(r+1:m,j) * A(r,j+1:n),2); 
      end      
   end
end                               % If requested, also calculate reduced echelon matrix R.
if nargout==5; R=zeros(size(A)); for j=1:r, R(j,v(j):end)=A(j,v(j):end); end  % Initialize
   for j=r:-1:1, R(j,:) = mod((R(j,:) - R(j,v(j+1:r))*R(j+1:r,:)) / R(j,v(j)),2); end
end % (the above computation just elimates the elements above the pivots, then normalizes)
