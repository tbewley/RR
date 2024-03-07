function [A] = CholeskyIncomplete(A,n)
% function [A] = CholeskyIncomplete(A,n)
% Compute the incomplete Cholesky decomposition G*G^H of some A>0.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

for i=1:n
   for j=i+1:n, for k=i+1:n, 
      if (A(j,k)~=0) A(j,k)=A(j,k)-A(j,i)*A(k,i)'./A(i,i); end;
   end; end;
   A(i,i)=sqrt(A(i,i));
   for j=i+1:n, if (A(j,i)~=0) A(j,i)=A(j,i)/A(i,i); end; end;
   A(i,i+1:n)=0;
end
end % function CholeskyIncomplete
