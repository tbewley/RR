function p=RR_Prod(a)
% function p=RR_Prod(a)
% Compute the product p of the elements in the vector a.
% INPUTS: a = vector
% OUTPUT: p = product of the elements in the vector a
% TEST:   a=[2 4 5], p=RR_Prod(a)
% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

p=a(1); for i=2:length(a); p=p*a(i); end
end % function RR_Prod
