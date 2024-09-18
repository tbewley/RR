function [g,A]=RR_gcd_vec(A)

[m,n]=size(A); b=abs(reshape(A,m*n,1));
g=RR_gcd(RR_int64(b(1)),RR_int64(b(2)));
for i=3:m*n, g=RR_gcd(g,RR_int64(b(i))); end
g=double(g.v); A=A/g;