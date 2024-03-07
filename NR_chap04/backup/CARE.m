function X=RC_CARE(A,S,Q)
% function X=RC_CARE(A,S,Q)
% This function finds the X that satisfies A' X + X A - X S X + Q = 0, with Q >= 0, S >= 0.
% Defining S=B R^{-1} B', we also assume (A,B) is stabilizable and (A,Q) is detectable.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

n=size(A,1); [U,T]=RC_Schur([A -S; -Q -A']);
[U,T]=RC_ReorderSchur(U,T,'lhp');  X=RC_GaussPP(U(1:n,1:n)',U(n+1:2*n,1:n)',n);
end % function RC_CARE
