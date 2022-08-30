function c=RR_choose(n,k)
% function c=RR_choose(n,k)
% Compute the "choose" function
% INPUTS:  n,k integers
% OUTPUT:  c = (n choose k) = n!/(k! (n-k)!)
% Numerical Renaissance codebase, Appendix A, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

c=RR_Factorial(n)/(RR_Factorial(k)*RR_Factorial(n-k));
end % function RR_Choose
