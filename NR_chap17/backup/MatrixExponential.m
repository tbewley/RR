function [Phi]=RC_MatrixExponential(A,t)
% function [Phi]=RC_MatrixExponential(A,t)
% Compute Phi=e^(At) for square A and t>0 by first selecting m such that,
% Psi(ti)=||A*ti||<1 where ti=t/2^m, then computing Psi(ti) using (20.17b),
% then determining Psi(t) using (20.18), and finally extracting Phi(t) using (20.17a).
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.1.2.4.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help RC_MatrixExponentialTest">RC_MatrixExponentialTest</a>.

c=log2(norm(A*t,1)); m=max(0,floor(c)+1); ti=t/(2^m); n=length(A); Psi=zeros(n); kmax=15;
Psi=(eye(n)+A*ti/kmax); for k=kmax-1:-1:2, Psi=eye(n)+(A*ti/k)*Psi; end
for j=1:m, Psi=(eye(n)+(A*(ti*2^j)/4)*Psi)*Psi; end, Phi=eye(n)+A*t*Psi;
end % function RC_MatrixExponential