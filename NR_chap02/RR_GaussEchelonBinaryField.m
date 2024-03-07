function [A,p,r,v,R] = RC_GaussEchelon(A)
% function [A,p,r,v,R] = RC_GaussEchelon(A)
% This function computes the PLU decomposition of a singular or nonsquare matrix A, where
% P is a permutation matrix, L is unit lower triangular, and U is in echelon form, using
% an extension of RC_Gaussian elimination with partial pivoting.  The matrix A is replaced by
% the m_ij and U on exit, p is the permutation vector, r is the rank, and v is a vector
% containing the column of each pivot.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% Verify with <a href="matlab:help RC_GaussEchelonTest">RC_GaussEchelonTest</a>.

[m,n]=size(A);  p=[1:m]';  r=0; v=[];             % Initialize rank = 0, no pivots
for j = 1:n,
   [amax,imax]=max(abs(A(r+1:m,j)));              % Find the max element in left column
   if amax > 0                                    % If it is nonzero, increment the rank,
      r=r+1; v(r)=j;                              % store this pivot location, and,
      if r<m                                      % if not in the very last row, then
         if amax > abs(A(r,j))                    % exchange rows if necessary ...
             A([r r-1+imax],:)=A([r-1+imax r],:);
             p([r r-1+imax])  =p([r-1+imax r]); 
         end                                      % then perform the RC_Gauss transformation.
         A(r+1:m,j)     = - A(r+1:m,j) / A(r,j);
         A(r+1:m,j+1:n) = A(r+1:m,j+1:n) + A(r+1:m,j) * A(r,j+1:n); 
      end      
   end
end                               % If requested, also calculate reduced echelon matrix R.
if nargout==5; R=zeros(size(A)); for j=1:r, R(j,v(j):end)=A(j,v(j):end); end  % Initialize
   for j=r:-1:1, R(j,:) = (R(j,:) - R(j,v(j+1:r))*R(j+1:r,:)) / R(j,v(j)); end
end % (the above computation just elimates the elements above the pivots, then normalizes)
end % function RC_GaussEchelon
