% script RC_ReorderSchurTest
% Test RC_ReorderSchur with random F and random Q>0.
% Numerical Renaissance Codebase 1.0, NRchap4; see text for copyleft info.

n=8; A=0.5*randn(n); [U,T]=RC_Schur(A);
[U,T]=RC_ReorderSchur(U,T,'lhp');          LHPfirst=diag(T),              res=norm(A-U*T*U')
[U,T]=RC_ReorderSchur(U,T,'unitdisk');     RadiusSort=abs(diag(T)),       res=norm(A-U*T*U')
[U,T]=RC_ReorderSchur(U,T,'absolute',.01); AbsoluteRealPartSort=diag(T),  res=norm(A-U*T*U')

% end script RC_ReorderSchurTest
