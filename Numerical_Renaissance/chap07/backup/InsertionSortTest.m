% script <a href="matlab:RR_InsertionSortTest">RR_InsertionSortTest</a>
% Test <a href="matlab:help RR_InsertionSort">RR_InsertionSort</a> on a random set of data.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 7.1.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap07">Chapter 7</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.

n=99; D=2*rand(n,1)-1; close all, plot(D(:,1),'x'), pause(0.1)
[D,index]=RR_InsertionSort(D,1,n);   plot(D(:,1),'x')

% end script RR_InsertionSortTest
