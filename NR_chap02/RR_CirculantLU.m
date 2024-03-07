function [G] = RC_CirculantLU(a,b,c,d,e,G,n)
% function [G] = RC_CirculantLU(a,b,c,d,e,G,n)
% This function uses the LU decomposition returned [in the (a,b,c,d,e) vectors] by a
% prior call to RC_Circulant.m to solve the system AX=G using forward / back substitution.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_Circulant. Verify with RC_CirculantTest.

for j = 1:n-1,
   G(j+1,:) = G(j+1,:) + a(j+1)*G(j,:);                     % FORWARD SURC_BSTITUTION
   G(n,:)   = G(n,:) + e(j)*G(j,:);
end                                  
G(n,:) = G(n,:) - e(n-1) * G(n-1,:);       
G(n,:) = G(n,:) / b(n);                                     % BACK SURC_BSTITUTION
G(n-1,:) = ( G(n-1,:) - d(n-1) * G(n,:) ) / b(n-1);
for i = n-2:-1:1,
   G(i,:) = ( G(i,:) - c(i) * G(i+1,:) - d(i) * G(n,:) ) / b(i);
end
end % function RC_CirculantLU
