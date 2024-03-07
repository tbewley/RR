function X=RR_CARE(A,S,Q)
% function X=RR_CARE(A,S,Q)
% This function finds the X that satisfies A' X + X A - X S X + Q = 0, with Q >= 0, S >= 0.
% Defining S=B R^{-1} B', we also assume (A,B) is stabilizable and (A,Q) is detectable.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.5.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RR_CALE, RR_DALE, RR_DARE. Depends on RR_Schur, RR_ReorderSchur, RR_GaussPP.
% Verify with RR_CAREtest.

n=size(A,1); [U,T]=RR_Schur([A -S; -Q -A']);
[U,T]=RR_ReorderSchur(U,T,'lhp');  X=RR_GaussPP(U(1:n,1:n)',U(n+1:2*n,1:n)',n);
end % function RR_CARE
