function X=RC_DALE(F,Q,n)
% function X=RC_DALE(F,Q,n)
% Compute the X that satisfies X = F X F^H + Q for full F and Hermitian Q.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

[U,T]=RC_Schur(F'); F0=T'; Q0=U'*Q*U; X0=RC_DALEtri(F0,Q0,n); X=U*X0*U'; 
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
