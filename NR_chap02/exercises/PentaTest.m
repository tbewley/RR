% script PentaTest
% Test Penta.m on a random pentadiagonal matrix.
% Note that this test script is NOT efficient, and is meant for TESTING PURPOSES ONLY.
% Numerical Renaissance Codebase 1.0, NRchap2; see text for copyleft info.

n=7; m=2; a=randn(n); b=randn(n); c=randn(n); d=randn(n); e=randn(n); G=randn(n,m);
A=diag(a(3:n),-2) + diag(b(2:n),-1) + diag(c(1:n),0) + diag(d(1:n-1),1) + diag(e(1:n-2),2)
X=Penta(a,b,c,d,e,G,n)
% X=Penta(a,b,c,d,e,G,n)
error=norm(A*X-G)

% end script PentaTest
