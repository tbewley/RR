function [G] = RC_ThomasLU(a,b,c,G,n)
% function [G] = RC_ThomasLU(a,b,c,G,n)
% This function uses the LU decomposition returned [in the modified (a,b,c) vectors] by a
% prior call to Thomas.m to solve the system AX=G using forward / back substitution.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also Thomas. Verify with RC_ThomasTest.

for j = 1:n-1,
   G(j+1,:) = G(j+1,:) + a(j+1)*G(j,:);                     % FORWARD SURC_BSTITUTION
end                                  
G(n,:) = G(n,:) / b(n);
for i = n-1:-1:1,
   G(i,:) = ( G(i,:) - c(i) * G(i+1,:) ) / b(i);            % BACK SURC_BSTITUTION
end
end % function RC_ThomasLU
