function [C] = RR_GaussPLU(Amod,B,p,n)
% function [C] = RR_GaussPLU(Amod,B,p,n)
% This function uses the PLU decomposition returned (in the modified A and p) by a prior
% call to RR_GaussPP to solve the system AX=B using forward / back substitution.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/NR_chap02
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 
% See also RR_GaussPP. Trial: RR_GaussPPTest.

for j=1:n, C(j,:)=B(p(j),:); end, [C] = RR_GaussLU(Amod,C,n);
end % function RR_GaussPLU
