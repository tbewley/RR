% script <a href="matlab:RC_TFnormTest">RC_TFnormTest</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.2.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear; n=4; ni=2; no=2;
R=randn(n); S=randn(n); A=-R*R'+S-S'; B=randn(n,ni); C=randn(no,n); D=randn(no,ni);
disp('Continuous-time system:'), RC_ShowSys(A,B,C,D), sys=ss(A,B,C,D); sys0=ss(A,B,C,0);
disp('RC_Eigenvalues of A (note: Hurwitz)'); disp(RC_Eig(A,'r')),
fprintf('2-norm   of CT transfer function (setting D=0): %g (Matlab toolbox: %g)\n', ...
  RC_TFnorm(A,B,C,0*D,'2','CT'), norm(sys0))
fprintf('inf-norm of CT transfer function (full system): %g (Matlab toolbox: %g)\n\n', ...
  RC_TFnorm(A,B,C,D,'inf','CT'), norm(sys,'inf')), pause

F=randn(n); F=0.95*F/max(abs(RC_Eig(F,'r'))); G=randn(n,ni); H=randn(no,n); D=randn(no,ni);
disp('Discrete-time system:'), RC_ShowSys(F,G,H,D),  sys=ss(F,G,H,D,0.1);
disp('RC_Eigenvalues of F (note: stable)'); disp(RC_Eig(F,'r')),
fprintf('2-norm   of DT transfer function: %g (Matlab toolbox: %g)\n',...
  RC_TFnorm(F,G,H,D,'2','DT'), norm(sys))
fprintf('inf-norm of DT transfer function: %g (Matlab toolbox: %g)\n\n',...
  RC_TFnorm(F,G,H,D,'inf','DT'), norm(sys,'inf')), pause

F(:,1)=F(:,2); F=0.95*F/max(abs(RC_Eig(F,'r'))); D=0*D;
disp('Discrete-time system with singular F and D=0 (and, thus, singular F_tilde):')
RC_ShowSys(F,G,H,D),  sys=ss(F,G,H,D,0.1);
disp('RC_Eigenvalues of F (note: stable, but singular)'); disp(RC_Eig(F,'r')),
fprintf('2-norm   of DT transfer function: %g (Matlab toolbox: %g)\n',...
  RC_TFnorm(F,G,H,D,'2','DT'), norm(sys))
fprintf('inf-norm of DT transfer function: %g (Matlab toolbox: %g)\n\n',...
  RC_TFnorm(F,G,H,D,'inf','DT'), norm(sys,'inf'))

disp('Next <a href="matlab:help RCchap20">RCchap20</a> demo: <a href="matlab:RC_TF2MarkovTest">RC_TF2MarkovTest</a>'), disp(' ')
% end script RC_TFnormTest
