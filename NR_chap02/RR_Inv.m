function [A]=RR_Inv(A)
% function [A]=RR_Inv(A)
% Compute the inverse of a nonsingular matrix.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap02
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% Depends on RR_GaussPP

n=length(A); [A]=RR_GaussPP(A,eye(n),n);
% end function RR_Inv
