% script <a href="matlab:RC_SS2MarkovTest">RC_SS2MarkovTest</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.3.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

n=5; ni=1; no=1; A=randn(n,n); B=randn(n,ni); C=randn(no,n); D=randn(no,ni);
disp('Random SS system:'),  RC_ShowSys(A,B,C,D), MarkovFromSS=RC_SS2Markov(A,B,C,D,n+1)
[num,den]=RC_SS2TF(A,B,C,D), MarkovFromTF=RC_TF2Markov(num,den)

disp(' '); disp('Next <a href="matlab:help RCchap20">RCchap20</a> demo: <a href="matlab:RC_TF2SSTest">RC_TF2SSTest</a>'), disp(' ')
% end script RC_SS2MarkovTest