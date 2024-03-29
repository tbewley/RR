% script <a href="matlab:RR_CtrbMatrixTest">RR_CtrbMatrixTest</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Sections 20.5.1.1 and 20.5.3.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear; n=4; ni=2; A=randn(n,n); B=randn(n,ni);
disp('System {A,B}:'), RR_ShowSys(A,B), [CM,r]=RR_CtrbMatrix(A,B), disp(' ')

disp('Next <a href="matlab:help RCchap20">RCchap20</a> demo: <a href="matlab:RR_CtrbGrammianTest">RR_CtrbGrammianTest</a>'), disp(' ')
% end script RR_CtrbMatrixTest