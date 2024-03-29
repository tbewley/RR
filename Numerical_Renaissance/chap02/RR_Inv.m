function [A]=RR_Inv(A)
% function [A]=RR_Inv(A)
% Compute the inverse of a nonsingular matrix.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap02
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 
% Depends on RR_GaussPP

n=length(A); [A]=RR_GaussPP(A,eye(n),n);
% end function RR_Inv
