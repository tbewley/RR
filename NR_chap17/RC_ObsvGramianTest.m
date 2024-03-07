% script <a href="matlab:RC_ObsvGramianTest">RC_ObsvGramianTest</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Sections 20.5.2.2 and 20.5.4.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear, N=4; Nob=2; Ni=2; No=1; Nnob=N-Nob;
R1=randn(Nob); S1=randn(Nob); R2=randn(Nnob); S2=randn(Nnob);
A=[-R1*R1'+S1-S1' zeros(Nob,Nnob); ...
   randn(Nnob,Nob) -R2*R2'+S2-S2'];
B=randn(N,Ni); C=[randn(No,Nob) zeros(No,Nnob)];
disp(sprintf('Initial continuous-time system with %d observable modes:',Nob))
RC_ShowSys(A,B,C), disp('RC_Eigenvalues of A (need to be in LHP!)'); disp(RC_Eig(A,'r'))
[A,B,C]=RC_SSTransform(A,B,C,randn(N)); disp('Scramble this system:'), RC_ShowSys(A,B,C)
[Q,rob]=RC_ObsvGramian(A,C,'CT'), e=RC_Eig(Q,'h'); RC_Eigenvalues_of_Q=e(N:-1:1);
disp('Error (that is, norm of A''*Q+Q*A+C''*C):'), disp(norm(A'*Q+Q*A+C'*C)), pause

disp(' '), F1=randn(Nob); F2=randn(Nnob);
F=[0.95*F1/max(abs(RC_Eig(F1,'r'))) zeros(Nob,Nnob); ...
   randn(Nnob,Nob) 0.95*F2/max(abs(RC_Eig(F2,'r')))];
G=randn(N,Ni); H=[randn(No,Nob) zeros(No,Nob)];
disp(sprintf('Initial discrete-time system with %d controllable modes:',Nob))
RC_ShowSys(F,G,H), disp('RC_Eigenvalues of F (need to be inside unit circle!)'); disp(RC_Eig(F,'r'))
[F,G,H]=RC_SSTransform(F,G,H,randn(N)); disp('Scramble this system:'), RC_ShowSys(F,G,H)
[Q,rob]=RC_ObsvGramian(F,H,'DT'), e=RC_Eig(Q,'h'); RC_Eigenvalues_of_Q=e(N:-1:1);
disp('Error (that is, norm of Q-F''*Q*F-H''*H):'), disp(norm(Q-F'*Q*F-H'*H))

disp(' '); disp('Next <a href="matlab:help RCchap20">RCchap20</a> demo: <a href="matlab:RC_SS2CanonicalFormTest">RC_SS2CanonicalFormTest</a>'), disp(' ')
% end script RC_ObsvGramianTest