function [A,U,V] = Bidiagonalization(A,m,n)
% function [A,U,V] = Bidiagonalization(A,m,n)
% Pre and post-multiply an mxn matrix A by a sequence of Householder reflections
% to reduce it to upper bidiagonal form B, thus computing the decomposition A=U B V^H.
% Numerical Renaissance Codebase 1.0, NRchap1; see text for copyleft info.

V=eye(n,n); U=eye(m,m); 
for i=1:min(m,n)
  if i<m, [sig,w] = ReflectCompute(A(i:m,i));
          A=Reflect(A,sig,w,i,  m,i,n,'L'); U=Reflect(U,sig,w,i,  m,1,m,'R'); end
  if i<n, [sig,w] = ReflectCompute(A(i,i+1:n)');
          A=Reflect(A,sig,w,i+1,n,i,m,'R'); V=Reflect(V,sig,w,i+1,n,2,n,'R'); end
end
end % function Bidiagonalization
