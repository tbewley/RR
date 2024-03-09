function out = RR_Factorial(b)
% function out = RR_Factorial(b)
% Compute the factorial of each element of the matrix b.
% INPUT:  a=matrix of integers
% OUTPUT: b=matrix of integers with b(i,j)=factorial(a(i,j))
% TEST:   b=[1 2 3; 4 5 6], a=RR_Factorial(b)
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/RR_chapAA
% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

[n,m]=size(b); for i=1:n,for j=1:m, out(i,j)=1; for k=2:b(i,j); out(i,j)=out(i,j)*k; end,end,end
end % function RR_Factorial
