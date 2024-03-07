% script CGquadBigTest                               % Numerical Renaissance Codebase 1.0
N=200, A=randn(N); A=A'*A; condA=cond(A), b=rand(N,1); figure(1);
[x,FastRes]=CGquadFast(A,b); FastErr=norm(A*x-b)/norm(x), semilogy(FastRes,'b-');
[x,FastRes]=CGquadFast(A,b); FastErr=norm(A*x-b)/norm(x), semilogy(FastRes,'b-');
x=CG_quad_precon(A,b,N,10); err=norm(A*x-b)/norm(x)
% end script CGquadBigTest
