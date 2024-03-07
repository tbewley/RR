% script <a href="matlab:RR_ShowSysTest">RR_ShowSysTest</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.1
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear, N=3; Ni=2; No=1; A=randn(N), B=randn(N,Ni), C=randn(No,N), D=randn(No,Ni)
disp('Full system:'),  RR_ShowSys(A,B,C,D), pause
disp('{A,B,C} only:'), RR_ShowSys(A,B,C),   pause
disp('{A,B} only:'),   RR_ShowSys(A,B),     pause
disp('{A,C} only:'),   RR_ShowSys(A,C)

disp(' '); disp('Next <a href="matlab:help RCchap20">RCchap20</a> demo: <a href="matlab:RR_SSTransformTest">RR_SSTransformTest</a>'), disp(' ')
% end script RR_ShowSysTest