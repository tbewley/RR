function [g,A]=RR_gcd_vec(A)
% INPUT:  A = a matrix with integer elements
% OUTPUT: g = the greatest common divisor of the elements of A
%         A = the input matrix divided by g
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

[m,n]=size(A); b=abs(reshape(A,m*n,1));
g=RR_gcd(RR_int64(b(1)),RR_int64(b(2)));
for i=3:m*n, g=RR_gcd(g,RR_int64(b(i))); end
g=double(g.v); A=A/g;