function [G,a,b,c,d,e] = Penta(a,b,c,d,e,G,n)
% function [G,a,b,c,d,e] = Penta(a,b,c,d,e,G,n)
% This function solves AX=G for X using a simplified form of RC_Gaussian elimination,
% where A = pentadiag(a,b,c,d,e).  The five diagonals of A are replaced by the m_ij
% and U on exit, and the matrix G is replaced by the solution X of the original system.
% Numerical Renaissance Codebase 1.0, NRchap2; see text for copyleft info.

for j = 1:n-2,
   b(j+1)   = - b(j+1) / c(j);
   c(j+1)   = c(j+1)   + b(j+1)*d(j);
   d(j+1)   = d(j+1)   + b(j+1)*e(j);
   G(j+1,:) = G(j+1,:) + b(j+1)*G(j,:);
   a(j+2)   = - a(j+2) / c(j);
   b(j+2)   = b(j+2)   + a(j+2)*d(j);
   c(j+2)   = c(j+2)   + a(j+2)*e(j);
   G(j+2,:) = G(j+2,:) + a(j+2)*G(j,:);
end
b(n)   = - b(n) / c(n-1);
c(n)   = c(n)   + b(n)*d(n-1);
G(n,:) = G(n,:) + b(n)*G(n-1,:);

G(n,  :) = G(n,:) / c(n);
G(n-1,:) = ( G(n-1,:) - d(n-1) * G(n,:) ) / c(n-1);
for i = n-2:-1:1,
   G(i,:) = ( G(i,:) - d(i) * G(i+1,:) - e(i) * G(i+2,:) ) / c(i);
end
end % function RC_Penta
