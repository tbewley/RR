% script <a href="matlab:RR_ObsvMatrixTest">RR_ObsvMatrixTest</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Sections 20.5.2.1 and 20.5.4.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear, N=4; Nob=2; Ni=2; No=2; Nnob=N-Nob;
A=[randn(Nob) zeros(Nob,Nnob); ...
   randn(Nnob,Nob) randn(Nnob)];
B=randn(N,Ni); C=[randn(No,Nob) zeros(No,Nnob)];
disp(sprintf('Initial continuous-time system with %d observable modes:',Nob))
RR_ShowSys(A,B,C)
[A,B,C]=RR_SSTransform(A,B,C,randn(N)); disp('Scramble this system:'), RR_ShowSys(A,B,C)
[OM,r]=RR_ObsvMatrix(A,C)

disp(' '); disp('Next <a href="matlab:help RCchap20">RCchap20</a> demo: <a href="matlab:RR_ObsvGramianTest">RR_ObsvGramianTest</a>'), disp(' ')
% end script RR_ObsvMatrixTest