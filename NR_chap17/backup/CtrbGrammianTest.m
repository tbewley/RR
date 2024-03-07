% script <a href="matlab:RC_CtrbGrammianTest">RC_CtrbGrammianTest</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Sections 20.5.1.2 and 20.5.3.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear, N=4; Nc=2; Ni=2; No=1; Nnc=N-Nc;
R1=randn(Nc); S1=randn(Nc); R2=randn(Nnc); S2=randn(Nnc);
A=[-R1*R1'+S1-S1' randn(Nc,Nnc); ...
   zeros(Nnc,Nc) -R2*R2'+S2-S2'];
B=[randn(Nc,Ni); zeros(Nnc,Ni)]; C=randn(No,N);
disp(sprintf('Initial continuous-time system with %d controllable modes:',Nc))
RC_ShowSys(A,B,C), disp('RC_Eigenvalues of A (need to be in LHP!)'); disp(RC_Eig(A,'r'))
[A,B,C]=RC_SSTransform(A,B,C,randn(N)); disp('Scramble this system:'), RC_ShowSys(A,B,C)
[P,rc]=RC_CtrbGrammian(A,B,'CT'), e=RC_Eig(P,'h'); RC_Eigenvalues_of_P=e(N:-1:1);
disp('Error (that is, norm of A*P+P*A''+B*B''):'), disp(norm(A*P+P*A'+B*B')), pause

disp(' '), F1=randn(Nc); F2=randn(Nnc);
F=[0.95*F1/max(abs(RC_Eig(F1,'r'))) randn(Nc,Nnc); ...
   zeros(Nnc,Nc) 0.95*F2/max(abs(RC_Eig(F2,'r')))];
G=[randn(Nc,Ni); zeros(Nnc,Ni)]; H=randn(No,N);
disp(sprintf('Initial discrete-time system with %d controllable modes:',Nc))
RC_ShowSys(F,G,H), disp('RC_Eigenvalues of A (need to be inside unit circle!)'); disp(RC_Eig(F,'r'))
[F,G,H]=RC_SSTransform(F,G,H,randn(N)); disp('Scramble this system:'), RC_ShowSys(F,G,H)
[P,rc]=RC_CtrbGrammian(F,G,'DT'), e=RC_Eig(P,'h'); RC_Eigenvalues_of_P=e(N:-1:1);
disp('Error (that is, norm of P-F*P*F''-G*G''):'), disp(norm(P-F*P*F'-G*G')), disp(' ')

disp('Next <a href="matlab:help RCchap20">RCchap20</a> demo: <a href="matlab:RC_ObsvMatrixTest">RC_ObsvMatrixTest</a>'), disp(' ')
% end script RC_CtrbGrammianTest