function [A] = Cholesky(A,n)
% function [A] = Cholesky(A,n)
% Compute the full Cholesky decomposition A=G*G^H of some A>0.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

for i=1:n
   A(i+1:n,i+1:n)=A(i+1:n,i+1:n)-A(i+1:n,i)*A(i+1:n,i)'./A(i,i);
   A(i,i)=sqrt(A(i,i)); A(i+1:n,i)=A(i+1:n,i)/A(i,i); A(i,i+1:n)=0;
end
end % function Cholesky
