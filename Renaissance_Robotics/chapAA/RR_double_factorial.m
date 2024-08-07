function d=RR_double_factorial(n)
% function d=RR_double_factorial(n)
% Compute the double factorial for integer n, defined as:
% n!!=n*(n-2)*(n-4)*...*6*4*2 for odd n
% n!!=n*(n-2)*(n-4)*...*5*3*1 for even n
% TEST: for i=1:12; disp(sprintf('i=%0.3g, i!!=%0.5g',i,RR_double_factorial(i))), end
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

if n<2,             d=1;
elseif mod(n,2)==0, d=2^(n/2)*factorial(n/2);
else,               d=factorial(n)/RR_double_factorial(n-1);
end
end % function RR_double_factorial