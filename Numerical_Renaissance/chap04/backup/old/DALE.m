function X=RR_DALE(F,Q)                                 % Numerical Renaissance Codebase 1.0
% This function finds the X that satisfies X = F^H X F + Q, where F and Q are full
% and Q is Hermitian.
n=size(F,1); [U,F0]=RR_Schur(F); Q0=U'*Q*U; X0=RR_DALEtri(F0,Q0,n); X=U*X0*U'; 
end % function RR_DALE.m