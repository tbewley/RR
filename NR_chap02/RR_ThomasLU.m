function [G] = RR_ThomasLU(a,b,c,G,n)
% function [G] = RR_ThomasLU(a,b,c,G,n)
% This function uses the LU decomposition returned [in the modified (a,b,c) vectors] by a
% prior call to Thomas.m to solve the system AX=G using forward / back substitution.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap02
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 
% See also Thomas. Trial: RR_ThomasTest.

for j = 1:n-1,
   G(j+1,:) = G(j+1,:) + a(j+1)*G(j,:);                     % FORWARD SURR_BSTITUTION
end                                  
G(n,:) = G(n,:) / b(n);
for i = n-1:-1:1,
   G(i,:) = ( G(i,:) - c(i) * G(i+1,:) ) / b(i);            % BACK SURR_BSTITUTION
end
end % function RR_ThomasLU
