% script <a href="matlab:RC_BalancedRealizationTest">RC_BalancedRealizationTest</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.6.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear, disp(' '), n=4; ni=1; no=1;
R=randn(n); S=randn(n); A=-R*R'+S-S'; B=randn(n,ni); C=randn(no,n);
disp('Initial continuous-time system {A,B,C,D}:'), RC_ShowSys(A,B,C)
disp('RC_Eigenvalues of A (need to be in LHP!)'); disp(RC_Eig(A))
[Ab,Bb,Cb,HankelSingularValues]=RC_BalancedRealization(A,B,C,'CT');
disp('Balanced realization {Ab,Bb,Cb,Db}:'), RC_ShowSys(Ab,Bb,Cb)
disp('Hankel singular values:'), disp(HankelSingularValues') 
ControllabilityGrammian=RC_CtrbGrammian(Ab,Bb,'CT')
ObservabilityGrammian=RC_ObsvGrammian(Ab,Cb,'CT'), pause

disp(' '), F=randn(n); F=0.95*F/max(abs(RC_Eig(F,'r'))); G=randn(n,ni); H=randn(no,n);
disp('Initial discrete-time system {F,G,H,D}:'), RC_ShowSys(A,B,C)
disp('RC_Eigenvalues of F (need to be inside unit circle!)'); disp(RC_Eig(F,'r'))
[Fb,Gb,Hb,HankelSingularValues]=RC_BalancedRealization(F,G,H,'DT');
disp('Balanced realization {Fb,Gb,Hb,D}:'), RC_ShowSys(Fb,Bb,Cb)
disp('Hankel singular values:'), disp(HankelSingularValues') 
ControllabilityGrammian=RC_CtrbGrammian(Fb,Gb,'DT')
ObservabilityGrammian=RC_ObsvGrammian(Fb,Hb,'DT')

% end script RC_BalancedRealizationTest