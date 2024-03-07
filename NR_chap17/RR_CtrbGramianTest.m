% script RR_CtrbGramianTest

clear, N=4; Nc=2; Ni=2; No=1; Nnc=N-Nc;
R1=randn(Nc); S1=randn(Nc); R2=randn(Nnc); S2=randn(Nnc);
A=[-R1*R1'+S1-S1' randn(Nc,Nnc); ...
   zeros(Nnc,Nc) -R2*R2'+S2-S2'];
B=[randn(Nc,Ni); zeros(Nnc,Ni)]; C=randn(No,N);
disp(sprintf('Initial continuous-time system with %d controllable modes:',Nc))
RR_ShowSys(A,B,C), disp('RR_Eigenvalues of A (need to be in LHP!)'); disp(RR_Eig(A,'r'))
[A,B,C]=RR_SSTransform(A,B,C,randn(N)); disp('Scramble this system:'), RR_ShowSys(A,B,C)
[P,rc]=RR_CtrbGramian(A,B,'CT'), e=RR_Eig(P,'h'); RR_Eigenvalues_of_P=e(N:-1:1);
disp('Error (that is, norm of A*P+P*A''+B*B''):'), disp(norm(A*P+P*A'+B*B')), pause

disp(' '), F1=randn(Nc); F2=randn(Nnc);
F=[0.95*F1/max(abs(RR_Eig(F1,'r'))) randn(Nc,Nnc); ...
   zeros(Nnc,Nc) 0.95*F2/max(abs(RR_Eig(F2,'r')))];
G=[randn(Nc,Ni); zeros(Nnc,Ni)]; H=randn(No,N);
disp(sprintf('Initial discrete-time system with %d controllable modes:',Nc))
RR_ShowSys(F,G,H), disp('RR_Eigenvalues of A (need to be inside unit circle!)'); disp(RR_Eig(F,'r'))
[F,G,H]=RR_SSTransform(F,G,H,randn(N)); disp('Scramble this system:'), RR_ShowSys(F,G,H)
[P,rc]=RR_CtrbGramian(F,G,'DT'), e=RR_Eig(P,'h'); RR_Eigenvalues_of_P=e(N:-1:1);
disp('Error (that is, norm of P-F*P*F''-G*G''):'), disp(norm(P-F*P*F'-G*G')), disp(' ')

disp('Next <a href="matlab:help RCchap20">RCchap20</a> demo: <a href="matlab:RR_ObsvMatrixTest">RR_ObsvMatrixTest</a>'), disp(' ')
% end script RR_CtrbGramianTest