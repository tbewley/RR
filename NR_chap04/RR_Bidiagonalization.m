function [A,U,V] = RC_Bidiagonalization(A,m,n)
% function [A,U,V] = RC_Bidiagonalization(A,m,n)
% Pre and post-multiply an mxn matrix A by a sequence of Householder reflections
% to reduce it to upper bidiagonal form B, thus computing the decomposition A=U B V^H.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.4.7.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_Hessenberg. Depends on ReflectCompute, Reflect.
% Verify with BidiagonalizationTest.

V=eye(n,n); U=eye(m,m); 
for i=1:min(m,n)
  if i<m, [sig,w] = RC_reflect_compute(A(i:m,i));
          A=RC_reflect(A,sig,w,i,  m,i,n,'L'); U=RC_reflect(U,sig,w,i,  m,1,m,'R'); end
  if i<n, [sig,w] = RC_reflect_compute(A(i,i+1:n)');
          A=RC_reflect(A,sig,w,i+1,n,i,m,'R'); V=RC_reflect(V,sig,w,i+1,n,2,n,'R'); end
end
end % function RC_Bidiagonalization
