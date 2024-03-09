function [B] = RR_GaussLU(Amod,B,n)
% function [B] = RR_GaussLU(Amod,B,n)
% This function uses the LU decomposition returned (in the modified A matrix) by a prior
% call to RR_Gauss.m to solve the system AX=B using forward and back substitution.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap02
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 
% See also RR_Gauss. Trial: RR_GaussTest.

for j = 2:n,
   B(j,:) = B(j,:) + Amod(j,1:j-1) * B(1:j-1,:);                  % FORWARD SURR_BSTITUTION
end
for i = n:-1:1,  
   B(i,:) = ( B(i,:) - Amod(i,i+1:n) * B(i+1:n,:) ) / Amod(i,i);  % BACK SURR_BSTITUTION
end
end % function RR_GaussLU
