function [A,den]=RR_rat(A)

[n,m]=size(A); den=1;
for i=1:n, for j=1:m, if abs(A(i,j))>1e-10,
  [n,d]=rat(A(i,j)); A=A*d; den=den*d;
end, end, end
A=round(A); [g,A]=RR_gcd_vec(A); den=den/g;