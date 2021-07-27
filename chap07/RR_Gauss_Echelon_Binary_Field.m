function [A,p,r,v,R] = GaussEchelon(A)
% function [A,p,r,v,R] = GaussEchelon(A)
% This function computes the PLU decomposition of a singular or nonsquare matrix A, where
% P is a permutation matrix, L is unit lower triangular, and U is in echelon form, using
% an extension of Gaussian elimination with partial pivoting.  The matrix A is replaced by
% the m_ij and U on exit, p is the permutation vector, r is the rank, and v is a vector
% containing the column of each pivot.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 2.6.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap02">Chapter 2</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% Verify with <a href="matlab:help GaussEchelonTest">GaussEchelonTest</a>.

[m,n]=size(A);  p=[1:m]';  r=0; v=[];             % Initialize rank = 0, no pivots
for j = 1:n,
   [amax,imax]=max(abs(A(r+1:m,j)));              % Find the max element in left column
   if amax > 0                                    % If it is nonzero, increment the rank,
      r=r+1; v(r)=j;                              % store this pivot location, and,
      if r<m                                      % if not in the very last row, then
         if amax > abs(A(r,j))                    % exchange rows if necessary ...
             A([r r-1+imax],:)=A([r-1+imax r],:);
             p([r r-1+imax])  =p([r-1+imax r]); 
         end                                      % then perform the Gauss transformation.
         A(r+1:m,j)     = - A(r+1:m,j) / A(r,j);
         A(r+1:m,j+1:n) = A(r+1:m,j+1:n) + A(r+1:m,j) * A(r,j+1:n); 
      end      
   end
end                               % If requested, also calculate reduced echelon matrix R.
if nargout==5; R=zeros(size(A)); for j=1:r, R(j,v(j):end)=A(j,v(j):end); end  % Initialize
   for j=r:-1:1, R(j,:) = (R(j,:) - R(j,v(j+1:r))*R(j+1:r,:)) / R(j,v(j)); end
end % (the above computation just elimates the elements above the pivots, then normalizes)
end % function GaussEchelon
