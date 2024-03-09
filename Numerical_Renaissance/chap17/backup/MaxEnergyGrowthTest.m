% script <a href="matlab:RR_MaxEnergyGrowthTest">RR_MaxEnergyGrowthTest</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.1.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear; n=4; Q=rand(n); Q=Q*Q';

R=randn(n); S=randn(n); A=-R*R'+S-S', tau=1,
disp('RR_Eigenvalues of A (note: stable system with eigenvalues in LHP)');
disp(RR_Eig(A,'r')), [thetamax,x0]=RR_MaxEnergyGrowth(A,Q,tau,'CT')
xtau=RR_MatrixExponential(A,tau)*x0; E0=x0'*Q*x0, Etau=xtau'*Q*xtau, disp(' '), pause

F=randn(n); F=0.95*F/max(abs(RR_Eig(F,'r'))), m=8,
disp('RR_Eigenvalues of F (note: stable system with eigenvalues in unit circle)');
disp(RR_Eig(F,'r')), [thetamax,x0]=RR_MaxEnergyGrowth(F,Q,m,'DT')
xm=F^m*x0; E0=x0'*Q*x0, Em=xm'*Q*xm, disp(' ')

disp('Next <a href="matlab:help RCchap20">RCchap20</a> demo: <a href="matlab:RR_TFnormTest">RR_TF2MarkovTest</a>'), disp(' ')
% end script RR_MaxEnergyGrowthTest
