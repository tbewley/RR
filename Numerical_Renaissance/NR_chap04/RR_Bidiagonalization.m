function [A,U,V] = RR_Bidiagonalization(A,m,n)
% function [A,U,V] = RR_Bidiagonalization(A,m,n)
% Pre and post-multiply an mxn matrix A by a sequence of Householder reflections
% to reduce it to upper bidiagonal form B, thus computing the decomposition A=U B V^H.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.4.7.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RR_Hessenberg. Depends on ReflectCompute, Reflect.
% Trial: BidiagonalizationTest.

V=eye(n,n); U=eye(m,m); 
for i=1:min(m,n)
  if i<m, [sig,w] = RR_reflect_compute(A(i:m,i));
          A=RR_reflect(A,sig,w,i,  m,i,n,'L'); U=RR_reflect(U,sig,w,i,  m,1,m,'R'); end
  if i<n, [sig,w] = RR_reflect_compute(A(i,i+1:n)');
          A=RR_reflect(A,sig,w,i+1,n,i,m,'R'); V=RR_reflect(V,sig,w,i+1,n,2,n,'R'); end
end
end % function RR_Bidiagonalization
