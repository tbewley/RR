% script <a href="matlab:RR_BlockInsertionSortTest">RR_BlockInsertionSortTest</a>
% Test <a href="matlab:help RR_BlockInsertionSort">RR_BlockInsertionSort</a> on a random set of data.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 

n=99; D=2*rand(n,1)-1; close all,    plot(D(:,1),'x'), pause(0.1)
[D,index]=RR_BlockInsertionSort(D,1,n); plot(D(:,1),'x')

% end script RR_BlockInsertionSortTest
