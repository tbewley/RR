function [B] = RC_GaussLU(Amod,B,n)
% function [B] = RC_GaussLU(Amod,B,n)
% This function uses the LU decomposition returned (in the modified A matrix) by a prior
% call to RC_Gauss.m to solve the system AX=B using forward and back substitution.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_Gauss. Verify with RC_GaussTest.

for j = 2:n,
   B(j,:) = B(j,:) + Amod(j,1:j-1) * B(1:j-1,:);                  % FORWARD SURC_BSTITUTION
end
for i = n:-1:1,  
   B(i,:) = ( B(i,:) - Amod(i,i+1:n) * B(i+1:n,:) ) / Amod(i,i);  % BACK SURC_BSTITUTION
end
end % function RC_GaussLU
