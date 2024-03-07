function [B] = RC_GaussPLUQT(Amod,B,p,q,n)
% function [B] = RC_GaussPLUQT(Amod,B,p,q,n)
% This function uses the PLUQ^T decomposition returned (in the modified A, p, and q) by a
% prior call to RC_GaussCP to solve the system AX=B using forward / back substitution.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_GaussCP. Verify with RC_GaussCPTest.

for j=1:n, C(j,:)=B(p(j),:); end, [C]=RC_GaussLU(Amod,C,n);  for j=1:n, B(q(j),:)=C(j,:); end
end % function RC_GaussPLUQT
