% script <a href="matlab:RR_BalancedRealizationTest">RR_BalancedRealizationTest</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.6.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear, disp(' '), n=4; ni=1; no=1;
R=randn(n); S=randn(n); A=-R*R'+S-S'; B=randn(n,ni); C=randn(no,n);
disp('Initial continuous-time system {A,B,C,D}:'), RR_ShowSys(A,B,C)
disp('RR_Eigenvalues of A (need to be in LHP!)'); disp(RR_Eig(A))
[Ab,Bb,Cb,HankelSingularValues]=RR_BalancedRealization(A,B,C,'CT');
disp('Balanced realization {Ab,Bb,Cb,Db}:'), RR_ShowSys(Ab,Bb,Cb)
disp('Hankel singular values:'), disp(HankelSingularValues') 
ControllabilityGrammian=RR_CtrbGrammian(Ab,Bb,'CT')
ObservabilityGrammian=RR_ObsvGrammian(Ab,Cb,'CT'), pause

disp(' '), F=randn(n); F=0.95*F/max(abs(RR_Eig(F,'r'))); G=randn(n,ni); H=randn(no,n);
disp('Initial discrete-time system {F,G,H,D}:'), RR_ShowSys(A,B,C)
disp('RR_Eigenvalues of F (need to be inside unit circle!)'); disp(RR_Eig(F,'r'))
[Fb,Gb,Hb,HankelSingularValues]=RR_BalancedRealization(F,G,H,'DT');
disp('Balanced realization {Fb,Gb,Hb,D}:'), RR_ShowSys(Fb,Bb,Cb)
disp('Hankel singular values:'), disp(HankelSingularValues') 
ControllabilityGrammian=RR_CtrbGrammian(Fb,Gb,'DT')
ObservabilityGrammian=RR_ObsvGrammian(Fb,Hb,'DT')

% end script RR_BalancedRealizationTest