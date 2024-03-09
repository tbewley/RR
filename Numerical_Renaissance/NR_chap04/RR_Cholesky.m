function [A] = Cholesky(A,n)
% function [A] = Cholesky(A,n)
% Compute the full Cholesky decomposition A=G*G^H of some A>0.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.4.8.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

for i=1:n
   A(i+1:n,i+1:n)=A(i+1:n,i+1:n)-A(i+1:n,i)*A(i+1:n,i)'./A(i,i);
   A(i,i)=sqrt(A(i,i)); A(i+1:n,i)=A(i+1:n,i)/A(i,i); A(i,i+1:n)=0;
end
end % function Cholesky
