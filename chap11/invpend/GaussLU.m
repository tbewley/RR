function [B] = GaussLU(Amod,B,n)                     % Numerical Renaissance Codebase 1.0
% This function uses the LU decomposition returned (in the modified A matrix) by a prior
% call to Gauss.m to solve the system AX=B using forward and back substitution.
for j = 1:n-1,
   B(j+1,:) = B(j+1,:) + Amod(j+1,1:j) * B(1:j,:);                % FORWARD SUBSTITUTION
end
B(n,:) = B(n,:) / Amod(n,n);   
for i = n-1:-1:1,  
   B(i,:) = ( B(i,:) - Amod(i,i+1:n) * B(i+1:n,:) ) / Amod(i,i);  % BACK SUBSTITUTION
end
end % function GaussLU.m
