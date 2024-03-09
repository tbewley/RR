function X=RR_DARE(F,S,Q,n)
% function X=RR_DARE(F,S,Q,n)
% Finds the X that satisfies X = F' X (I+ S X)^{-1} F + Q, with Q>=0, S>=0, and |F|<>0.
% This code uses an approach based on an ordered RR_Schur decomposition.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.5.4.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RR_CALE, RR_CARE, RR_DALE, RR_RDE, RR_DAREdoubling. Depends on RR_Schur, RR_ReorderSchur, RR_GaussPP.
% Trial: RR_DAREtest.

E=inv(F'); [U,T]=RR_Schur([F+S*E*Q -S*E; -E*Q E]); [U,T]=RR_ReorderSchur(U,T,'unitdisk');
X=RR_GaussPP(U(1:n,1:n)',U(n+1:2*n,1:n)',n);
end % function RR_DARE
