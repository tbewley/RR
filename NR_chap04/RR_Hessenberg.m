function [A,V] = RC_Hessenberg(A)
% function [A,V] = RC_Hessenberg(A)
% Pre and post-multiply an nxn matrix A by a sequence of Householder reflections to reduce
% it to upper RC_Hessenberg form T_0, thus computing the unitary similarity transformation
% A=V T_0 V^H.  
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.4.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Depends on <a href="matlab:help ReflectCompute">ReflectCompute</a>, <a href="matlab:help Reflect">Reflect</a>.

[m,n]=size(A);  if nargout>1, V=eye(n,n); end 
for i=1:n-2
   [sig,w] = RC_reflect_compute(A(i+1:n,i));  A=RC_reflect(A,sig,w,i+1,n,1,n,'B');
   if nargout>1, V=RC_reflect(V,sig,w,i+1,n,1,n,'R'); end
end
end % function RC_Hessenberg
