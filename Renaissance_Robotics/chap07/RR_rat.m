function [A,den]=RR_rat(A)
% function [A,den]=RR_rat(A)
% INPUT:  A = a matrix with real elements
% OUTPUT: A,den = A matrix with integer elements, and a positive integer, such that A/den
%                 is the same as the input matrix.
% TEST:   A=[2 2 2 -3;6 1 1 -4;1 6 1 -4;1 1 6 -4]; Ap=pinv(A), [Ap,den]=RR_rat(Ap), Ap/den
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

[m,n]=size(A); den=1;
for i=1:m, for j=1:n, if abs(A(i,j))>1e-10, a=A(i,j);
  [num,d]=rat(a); check=norm(a-num/d); A=A*d; den=den*d;
end, end, end
A=round(A); [g,A]=RR_gcd_vec(A); den=den/g;