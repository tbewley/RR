function X=RC_DALE(F,Q)
% function X=RC_DALE(F,Q)
% Compute the X that satisfies X = F X F^H + Q for full F and Hermitian Q.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.5.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_CALE, RC_CARE, RC_DARE. Depends on RC_Schur, RC_GaussPP.
% Verify with RC_DALEtest.

n=length(F); [U,T]=RC_Schur(F'); F0=T'; Q0=U'*Q*U; X0=RC_DALEtri(F0,Q0,n); X=U*X0*U';
end % function RC_DALE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function X=RC_DALEtri(F,Q,n)
% Compute the X that satisfies X = F^H X F + Q for lower-triangular F and Hermitian Q.
for i=1:n, f=F(i,i);
  X(i,i)     = Q(i,i) / (1-f*f');
  X(i+1:n,i) = RC_GaussPP( eye(n-i)-f'*F(i+1:n,i+1:n), Q(i+1:n,i)+f'*X(i,i)*F(i+1:n,i), n-i);
  X(i,i+1:n) = X(i+1:n,i)';
  Q(i+1:n,i+1:n) = Q(i+1:n,i+1:n) + X(i,i)*F(i+1:n,i)*F(i+1:n,i)' + ...
     + F(i+1:n,i)*(X(i,i+1:n)*F(i+1:n,i+1:n)') + (F(i+1:n,i+1:n)*X(i+1:n,i))*F(i+1:n,i)';
end
end % function RC_DALEtri
