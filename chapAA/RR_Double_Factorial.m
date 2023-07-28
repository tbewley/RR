 function d=RR_Double_Factorial(n)
% Computes the double factorial for integer n, defined as:
% n!!=n*(n-2)*(n-4)*...*6*4*2 for odd n
% n!!=n*(n-2)*(n-4)*...*5*3*1 for even n
% TEST: for i=1:10; i, d=RR_Double_Factorial(i), end
% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

if n<2,             d=1;
elseif mod(n,2)==0, d=2^(n/2)*factorial(n/2);
else,               d=factorial(n)/RR_Double_Factorial(n-1);
end
end % function RR_Double_Factorial