function X=RR_CALE(A,Q)
% function X=RR_CALE(A,Q)
% Compute the X that satisfies A X + X A' + Q = 0 for full A and Hermitian Q.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.5.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RR_Sylvester, RR_CARE, RR_DALE, RR_DARE. Depends on RR_Schur, RR_GaussPP.
% Verify with RR_CALEtest.

n=length(A); [U,T]=schur(A','complex'); A0=T'; Q0=U'*Q*U; X0=RR_CALEtri(A0,Q0,n); X=U*X0*U';
end % function RR_CALE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X=RR_CALEtri(A,Q,n)
% Compute the X that satisfies A X + X A' + Q = 0 for lower-triangular A and Hermitian Q.
for i=1:n
  X(i,i)     = -Q(i,i) / (A(i,i)+A(i,i)');
  X(i+1:n,i) = RR_GaussPP(A(i+1:n,i+1:n)+A(i,i)'*eye(n-i),-Q(i+1:n,i)-X(i,i)*A(i+1:n,i),n-i);
  X(i,i+1:n) = X(i+1:n,i)';
  Q(i+1:n,i+1:n) = Q(i+1:n,i+1:n) + A(i+1:n,i)*X(i+1:n,i)' + X(i+1:n,i)*A(i+1:n,i)';
end
end % function RR_CALEtri
