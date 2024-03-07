% script <a href="matlab:RC_ReorderSchurTest">RC_ReorderSchurTest</a>
% Test <a href="matlab:help RC_ReorderSchur">RC_ReorderSchur</a> with random F and random Q>0.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 4.5.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap04">Chapter 4</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

disp('Now testing RC_ReorderSchur with random F and random Q>0.')
n=8; A=0.5*randn(n); [U,T]=RC_Schur(A);
[U,T]=RC_ReorderSchur(U,T,'lhp');          LHPfirst=diag(T),              res=norm(A-U*T*U')
[U,T]=RC_ReorderSchur(U,T,'unitdisk');     RadiusSort=abs(diag(T)),       res=norm(A-U*T*U')
[U,T]=RC_ReorderSchur(U,T,'absolute',.01); AbsoluteRealPartSort=diag(T),  res=norm(A-U*T*U')
disp(' ')

% end script RC_ReorderSchurTest
