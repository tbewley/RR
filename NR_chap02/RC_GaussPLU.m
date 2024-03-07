function [C] = RC_GaussPLU(Amod,B,p,n)
% function [C] = RC_GaussPLU(Amod,B,p,n)
% This function uses the PLU decomposition returned (in the modified A and p) by a prior
% call to RC_GaussPP to solve the system AX=B using forward / back substitution.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_GaussPP. Verify with RC_GaussPPTest.

for j=1:n, C(j,:)=B(p(j),:); end, [C] = RC_GaussLU(Amod,C,n);
end % function RC_GaussPLU
