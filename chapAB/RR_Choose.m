function c=RR_Choose(n,k)
% Numerical Renaissance codebase, Appendix B, https://github.com/tbewley/NR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License. 

c=RR_Factorial(n)/(RR_Factorial(k)*RR_Factorial(n-k));
end % function RR_Choose
