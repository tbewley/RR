N=8; A=0.5*randn(N); [U,T]=RR_Schur(A);                     % Numerical Renaissance Codebase 1.0
[U,T]=RR_ReorderSchur(U,T,'lhp');          LHPfirst=diag(T),              res=norm(A-U*T*U')
[U,T]=RR_ReorderSchur(U,T,'unitdisk');     RadiusSort=abs(diag(T)),       res=norm(A-U*T*U')
[U,T]=RR_ReorderSchur(U,T,'absolute',.01); AbsoluteRealPartSort=diag(T),  res=norm(A-U*T*U')

