function [B,A,p] = RC_GaussPP(A,B,n)
% function [B,A,p] = RC_GaussPP(A,B,n)
% This function solves AX=B for X using RC_Gaussian elimination with partial pivoting.
% The matrix B is replaced by the solution X on exit, and (if requested) the matrix A
% is replaced by m_ij and U on exit, with the vector of pivots returned in p.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_GaussPLU. Verify with RC_GaussPPTest, Example_2_1.

p=[1:n]';                                     % initialize permutation vector
for j = 1:n-1,                                % FORWARD SWEEP
   [amax,imax]=max(abs(A(j:n,j)));            % Find the largest element in the column.
   if amax > abs(A(j,j))                      % If necessary, exchange the rows of A along
      A([j j-1+imax],:)=A([j-1+imax j],:);    % with the rows of the previously-determined
      B([j j-1+imax],:)=B([j-1+imax j],:);    % m_ij (stored in the subdiagonal elements
      p([j j-1+imax])  =p([j-1+imax j]);      % of A), the rows of the RHS matrix B, and
   end                                        % the rows of the permutation vector p.
% --- THE REMAINDER OF THIS FUNCTION IS IDENTICAL TO RC_Gauss.m ---
% ...
   A(j+1:n,j)     = - A(j+1:n,j) / A(j,j);
   A(j+1:n,j+1:n) = A(j+1:n,j+1:n) + A(j+1:n,j) * A(j,j+1:n);   % Outer product update
   B(j+1:n,:)     = B(j+1:n,:)     + A(j+1:n,j) * B(j,:);
end
for i = n:-1:1,                                                 % BACK SURC_BSTITUTION
   B(i,:) = ( B(i,:) - A(i,i+1:n) * B(i+1:n,:) ) / A(i,i);      % Inner product update
end
end % function RC_GaussPP
