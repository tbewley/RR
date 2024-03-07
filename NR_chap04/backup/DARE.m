function X=RR_DARE(F,S,Q,n)
% function X=RR_DARE(F,S,Q,n)
% Finds the X that satisfies X = F' X (I+ S X)^{-1} F + Q, with Q>=0, S>=0, and |F|<>0.
% This code uses an approach based on an ordered RR_Schur decomposition.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

E=inv(F'); [U,T]=RR_Schur([F+S*E*Q -S*E; -E*Q E]); [U,T]=RR_ReorderSchur(U,T,'unitdisk');
X=RR_GaussPP(U(1:n,1:n)',U(n+1:2*n,1:n)',n);
end % function RR_DARE
