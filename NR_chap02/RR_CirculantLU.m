function [G] = RR_CirculantLU(a,b,c,d,e,G,n)
% function [G] = RR_CirculantLU(a,b,c,d,e,G,n)
% This function uses the LU decomposition returned [in the (a,b,c,d,e) vectors] by a
% prior call to RR_Circulant.m to solve the system AX=G using forward / back substitution.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RR_Circulant. Verify with RR_CirculantTest.

for j = 1:n-1,
   G(j+1,:) = G(j+1,:) + a(j+1)*G(j,:);                     % FORWARD SURR_BSTITUTION
   G(n,:)   = G(n,:) + e(j)*G(j,:);
end                                  
G(n,:) = G(n,:) - e(n-1) * G(n-1,:);       
G(n,:) = G(n,:) / b(n);                                     % BACK SURR_BSTITUTION
G(n-1,:) = ( G(n-1,:) - d(n-1) * G(n,:) ) / b(n-1);
for i = n-2:-1:1,
   G(i,:) = ( G(i,:) - c(i) * G(i+1,:) - d(i) * G(n,:) ) / b(i);
end
end % function RR_CirculantLU
