function [A]=RC_Inv(A)
% function [A]=RC_Inv(A)
% Compute the inverse of a nonsingular matrix.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% Depends on RC_GaussPP

n=length(A); [A]=RC_GaussPP(A,eye(n),n);
% end function RC_Inv
