% script <a href="matlab:RC_QuickSortTest">RC_QuickSortTest</a>
% Test <a href="matlab:help RC_InsertionSort">RC_InsertionSort</a> on a random set of data.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

n=99; D=2*rand(n,1)-1; close all, plot(D(:,1),'x'), pause(0.5)
[D,index]=RC_QuickSort(D,1,n);       plot(D(:,1),'x')

% end script RC_QuickSortTest
