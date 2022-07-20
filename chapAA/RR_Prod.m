function p=NR_Prod(a)
% function p=NR_Prod(a)
% Compute the product p of the elements in the vector a.
% INPUTS: a = vector
% OUTPUT: p = product of the elements in the vector a
% TEST:   a=[2 4 5], p=NR_Prod(a)
% Numerical Renaissance codebase, Appendix A, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

p=a(1); for i=2:length(a); p=p*a(i); end
end % function NR_Prod
