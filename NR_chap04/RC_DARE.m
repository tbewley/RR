function X=RC_DARE(F,S,Q,n)
% function X=RC_DARE(F,S,Q,n)
% Finds the X that satisfies X = F' X (I+ S X)^{-1} F + Q, with Q>=0, S>=0, and |F|<>0.
% This code uses an approach based on an ordered RC_Schur decomposition.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.5.4.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_CALE, RC_CARE, RC_DALE, RC_RDE, RC_DAREdoubling. Depends on RC_Schur, RC_ReorderSchur, RC_GaussPP.
% Verify with RC_DAREtest.

E=inv(F'); [U,T]=RC_Schur([F+S*E*Q -S*E; -E*Q E]); [U,T]=RC_ReorderSchur(U,T,'unitdisk');
X=RC_GaussPP(U(1:n,1:n)',U(n+1:2*n,1:n)',n);
end % function RC_DARE
