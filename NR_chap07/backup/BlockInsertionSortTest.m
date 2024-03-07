% script <a href="matlab:RC_BlockInsertionSortTest">RC_BlockInsertionSortTest</a>
% Test <a href="matlab:help RC_BlockInsertionSort">RC_BlockInsertionSort</a> on a random set of data.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 7.1.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap07">Chapter 7</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

n=99; D=2*rand(n,1)-1; close all,    plot(D(:,1),'x'), pause(0.1)
[D,index]=RC_BlockInsertionSort(D,1,n); plot(D(:,1),'x')

% end script RC_BlockInsertionSortTest
