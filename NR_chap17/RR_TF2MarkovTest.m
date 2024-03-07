% script <a href="matlab:RC_TF2MarkovTest">RC_TF2MarkovTest</a>
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 20.3.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap20">Chapter 20</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

clear, n=5, m=3, b=rand(1,m), a=[1 rand(1,n-1)], MarkovFromTF=TF2Markov(b,a)
[A,B,C,D]=RC_TF2SS(b,a,'Controller');            MarkovFromSS=SS2Markov(A,B,C,D,n)

disp(' '); disp('Next <a href="matlab:help RCchap20">RCchap20</a> demo: <a href="matlab:RC_SS2MarkovTest">RC_SS2MarkovTest</a>'), disp(' ')
% end script RC_TF2MarkovTest