% script <a href="matlab:RR_TFnormTest">RR_TFnormTest</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.2.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear; n=4; ni=1; no=1;
R=randn(n); S=randn(n); A=-R*R'+S-S'; B=randn(n,ni); C=randn(no,n);
disp('Continuous-time system:'), RR_ShowSys(A,B,C)
disp('RR_Eigenvalues of A (note: Hurwitz)'); disp(RR_Eig(A,'r')),
fprintf('2-norm   of CT transfer function: %g\n',RR_TFnorm(A,B,C,'2','CT'))
fprintf('inf-norm of CT transfer function: %g\n',RR_TFnorm(A,B,C,'inf','CT'))
sys=ss(A,B,C,0); norm(sys), norm(sys,'inf'), disp(' ')

F=randn(n); F=0.95*F/max(abs(RR_Eig(F,'r'))); G=randn(n,ni); H=randn(no,n);
disp('Discrete-time system:'), RR_ShowSys(F,G,H)
disp('RR_Eigenvalues of F (note: Hurwitz)'); disp(RR_Eig(F,'r')),
fprintf('2-norm   of DT transfer function: %g\n',RR_TFnorm(F,G,H,'2','DT'))
fprintf('inf-norm of DT transfer function: %g\n',RR_TFnorm(F,G,H,'inf','DT'))
sys=ss(F,G,H,0,0.1); norm(sys), norm(sys,'inf')

disp('Next <a href="matlab:help RCchap20">RCchap20</a> demo: <a href="matlab:RR_TF2MarkovTest">RR_TF2MarkovTest</a>'), disp(' ')
% end script RR_TFnormTest
