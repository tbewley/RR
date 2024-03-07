function [G] = RC_ThomasTT(a,b,c,G,n)
% function [G] = RC_ThomasTT(a,b,c,G,n)
% Solves the system AX=G for X using the Thomas algorithm, assuming A is tridiagonal,
% Toeplitz, and diagonally dominant, with (a,b,c) the scalars on the subdiagonal, main
% diagonal, and superdiagonal of A.  On exit, the matrix G is replaced by the solution X.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% Verify with <a href="matlab:help RC_ThomasTTTest">RC_ThomasTTTest</a>.

bt(1)=b;                               
for j = 1:n-1,                         % FORWARD SWEEP
   m = - a / bt(j);                    % A temporary vector bt (of length n) is created by
   bt(j+1)  = b + m * c;               % this algorithm, but it doesn't store enough to
   G(j+1,:) = G(j+1,:) + m * G(j,:);   % later reconstruct the LU decomposition of A.
end                                    
G(n,:) = G(n,:) / bt(n);               % BACK SURC_BSTITUTION
for i = n-1:-1:1,
   G(i,:) = ( G(i,:) - c * G(i+1,:) ) / bt(i);
end
end % function RC_ThomasTT
