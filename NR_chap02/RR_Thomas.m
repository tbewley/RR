function [G,a,b,c] = RC_Thomas(a,b,c,G,n)
% function [G,a,b,c] = Thomas(a,b,c,G,n)
% This function solves AX=G for X using the Thomas algorithm, where A = tridiag(a,b,c).
% The solution X is returned on exit, and (if requested), the three diagonals of A are
% replaced by the m_ij and U.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_ThomasLU. Verify with RC_ThomasTest.

for j = 1:n-1,                               % FORWARD SWEEP
   a(j+1)   = - a(j+1) / b(j);               % This code is just a simplified version of
   b(j+1)   = b(j+1)   + a(j+1)*c(j);        % RC_Gauss.m (using a different notation for the
   G(j+1,:) = G(j+1,:) + a(j+1)*G(j,:);      % matrix and RHS vector), to which the reader
end                                          % is referred for explanatory comments.
G(n,:) = G(n,:) / b(n);                      % BACK SURC_BSTITUTION
for i = n-1:-1:1,                             
   G(i,:) = ( G(i,:) - c(i) * G(i+1,:) ) / b(i);
end
end % function RC_Thomas
