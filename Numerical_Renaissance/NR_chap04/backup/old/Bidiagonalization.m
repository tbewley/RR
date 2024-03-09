function [A,U,V] = Bidiagonalization(A,m,n)          % Numerical Renaissance Codebase 1.0
% Pre and post-multiply a complex mxn matrix A by a sequence of Householder reflections
% to reduce it to upper bidiagonal form B, thus computing the decomposition A=U B V^H.
V=eye(n,n); U=eye(m,m); 
for i=1:min(m,n)
   if i<m, [A(i:m,i:n),sigma,w] = Reflect(A(i:m,i:n));
           U(:,i:m)=U(:,i:m)-(U(:,i:m)*w)*(sigma*w'); end
   if i<n, [x,sigma,w] = Reflect(A(i,i+1:n)');
           A(:,i+1:n)=A(:,i+1:n)-(A(:,i+1:n)*w)*(sigma*w');
           V(:,i+1:n)=V(:,i+1:n)-(V(:,i+1:n)*w)*(sigma*w'); end
end
end % function Bidiagonalization.m