function [L] = RC_InvertL(L,n)
% function [L] = InvertL(L,n)
% This function computes the inverse of a lower-triangular matrix via forward substitution.
% Numerical Renaissance Codebase 1.0, NRchap2; see text for copyleft info.

for k = 1:n,
   L(k,k)=1/L(k,k);    
   for i=k+1:n
	  L(i,k) = - L(i,k:i-1) * L(k:i-1,k) / L(i,i);          % --- FORWARD SURC_BSTITUTION ---
   end
end
end % function RC_InvertL.m
