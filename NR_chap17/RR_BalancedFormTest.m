% script <a href="matlab:RC_BalancedFormTest">RC_BalancedFormTest</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.6.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear, n=8; ni=1; no=1;
R=randn(n); S=randn(n); A=-R*R'+S-S'; B=randn(n,ni); C=randn(no,n); D=randn(no,ni);
disp('Initial continuous-time system {A,B,C,D}:'), RC_ShowSys(A,B,C,D)
disp('RC_Eigenvalues of A (need to be in LHP!)'); disp(RC_Eig(A))
[Ab,Bb,Cb,HankelSingularValues]=RC_BalancedForm(A,B,C,'CT');
disp('Balanced realization {Ab,Bb,Cb,Db}:'), RC_ShowSys(Ab,Bb,Cb,D)
disp('Hankel singular values:'), disp(HankelSingularValues') 
ControllabilityGramian=RC_CtrbGramian(Ab,Bb,'CT')
ObservabilityGramian=RC_ObsvGramian(Ab,Cb,'CT'),

g.omega=logspace(-1,3,500); g.line=0;
disp('RC_Eigenvalues of A balanced'); disp(RC_Eig(Ab))
[numb,denb]=RC_SS2TF(Ab,Bb,Cb);
% figure(1);  clf; g.style='b-';  RC_bode(RR_tf(numb,denb),g);  hold on; disp(' '),
pause

nt=4; Abt=Ab(1:nt,1:nt); Bbt=Bb(1:nt,:); Cbt=Cb(:,1:nt); Dbt=D;
disp('Truncation of balanced realization:'), RC_ShowSys(Abt,Bbt,Cbt,Dbt)
ControllabilityGramian=RC_CtrbGramian(Abt,Bbt,'CT')
ObservabilityGramian=RC_ObsvGramian(Abt,Cbt,'CT'),

disp('RC_Eigenvalues of A balanced and truncated'); disp(RC_Eig(Abt))
[numbt,denbt]=RC_SS2TF(Abt,Bbt,Cbt);
% figure(1); g.style='r-'; RC_bode(RR_tf(numbt,denbt),g); disp(' '),
pause

F=randn(n); F=0.95*F/max(abs(RC_Eig(F,'r'))); G=randn(n,ni); H=randn(no,n);
disp('Initial discrete-time system {F,G,H,D}:'), RC_ShowSys(F,G,H,D)
disp('RC_Eigenvalues of F (need to be inside unit circle!)'); disp(RC_Eig(F,'r'))
[Fb,Gb,Hb,HankelSingularValues]=RC_BalancedForm(F,G,H,'DT');
disp('Balanced realization {Fb,Gb,Hb,D}:'), RC_ShowSys(Fb,Gb,Hb,D)
disp('Hankel singular values:'), disp(HankelSingularValues') 
ControllabilityGramian=RC_CtrbGramian(Fb,Gb,'DT')
ObservabilityGramian=RC_ObsvGramian(Fb,Hb,'DT'), disp(' '), pause

nt=n-1; Fbt=Fb(1:nt,1:nt); Gbt=Gb(1:nt,:); Hbt=Hb(:,1:nt);
disp('Truncation of balanced realization:'), RC_ShowSys(Fbt,Gbt,Hbt,D)
ControllabilityGramian=RC_CtrbGramian(Fbt,Gbt,'DT')
ObservabilityGramian=RC_ObsvGramian(Fbt,Hbt,'DT')
disp('Note: the truncated system is well balanced (with diagonal grammians) iff there')
disp('is a big gap between the truncated and retained Hankel singular values.'), disp(' ')
% end script RC_BalancedFormTest