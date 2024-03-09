function [A,V] = Hessenberg(A)                       % Numerical Renaissance Codebase 1.0
% Pre and post-multiply an nxn matrix A by a sequence of identical Householder reflections
% to reduce it to upper Hessenberg form T_0, thus computing the unitary similarity
% transformation A=V T_0 V^H.  The output V is optional.
[m,n]=size(A);  if nargout>1, V=eye(n,n); end 
for i=1:n-2
   [A(i+1:n,i:n),sigma,w] = Reflect(A(i+1:n,i:n));
   A(:,i+1:n)=A(:,i+1:n)-(A(:,i+1:n)*w)*(sigma*w');
   if nargout>1, V(:,i+1:n)=V(:,i+1:n)-(V(:,i+1:n)*w)*(sigma*w'); end
end
end % function Hessenberg.m
