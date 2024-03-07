% script <a href="matlab:RC_BitonicSortTest">RC_BitonicSortTest</a>
% Test <a href="matlab:help RC_BitonicSort">RC_BitonicSort</a> on a random set of data.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 7.2.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap07">Chapter 7</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

n=2^7; D=2*rand(n,1)-1; close all, plot(D(:,1),'x'), axis([1 n -1 1]), pause(0.5)
[D,index]=RC_BitonicSort(D,1,n);      plot(D(:,1),'x'), axis([1 n -1 1])

% end script RC_BitonicSortTest
