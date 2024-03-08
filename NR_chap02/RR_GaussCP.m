function [X,A,p,q] = RR_GaussCP(A,B,n)
% function [X,A,p,q] = RR_GaussCP(A,B,n)
% This function solves AX=B for X using RR_Gaussian elimination with complete pivoting.
% The solution X is returned on exit, and (if requested) the matrix A
% is replaced by m_ij and U on exit, with the vectors of pivots returned in p and q.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap02
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 
% See also RR_GaussPLUQT. Trial: RR_GaussCPTest.

p=[1:n]';  q=[1:n]';                              % initialize permutation vectors
for j = 1:n-1,                                    % FORWARD SWEEP
   [treal,tint]=max(abs(A(j:n,j:n)));             % Find the largest element in A(j:n,j:n)
   [amax,jmax]=max(treal); imax=tint(jmax); acurrent=abs(A(j,j));
   if imax > j & amax > acurrent                  % Exchange the rows of A along with the
      A([j j-1+imax],:)=A([j-1+imax j],:);        % rows of the previously-determined m_ij
      B([j j-1+imax],:)=B([j-1+imax j],:);        % (stored in the lower triangle of A), 
      p([j j-1+imax])  =p([j-1+imax j]);          % the rows of the RHS matrix B, and
   end                                            % the rows of the permutation vector p.
   if jmax > j & amax > acurrent                    
      A(:,[j j-1+jmax])=A(:,[j-1+jmax j]);        % Then, exchange the columns of A and
      q([j j-1+jmax])  =q([j-1+jmax j]);          % the rows of the permutation vector q.
   end
% --- THIS LINE IS FOLLOWED BY THE REMAINDER OF RR_Gauss.m ---
% ...
   A(j+1:n,j)     = - A(j+1:n,j) / A(j,j);
   A(j+1:n,j+1:n) = A(j+1:n,j+1:n) + A(j+1:n,j) * A(j,j+1:n);   % (Outer product update)
   B(j+1:n,:)     = B(j+1:n,:)     + A(j+1:n,j) * B(j,:);
end
for i = n:-1:1,                                                 % BACK SURR_BSTITUTION
   B(i,:) = ( B(i,:) - A(i,i+1:n) * B(i+1:n,:) ) / A(i,i);      % (Inner product update)
end
% --- AFTER THE REMAINDER OF RR_Gauss.m, ONE MORE LINE OF CODE FOLLOWS TO DESCRAMBLE B ---
for j=1:n, X(q(j),:)=B(j,:); end
end % function RR_GaussCP
