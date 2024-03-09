% script <a href="matlab:RR_OddEvenRR_MergeSortTest">RR_OddEvenRR_MergeSortTest</a>
% Test <a href="matlab:help RR_OddEvenRR_MergeSort">RR_OddEvenRR_MergeSort</a> on a random set of data.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 

n=2^7; D=2*rand(n,1)-1; close all, plot(D(:,1),'x'), axis([1 n -1 1]), pause(0.5)
[D,index]=RR_OddEvenRR_MergeSort(D,1,n); plot(D(:,1),'x'), axis([1 n -1 1])

% end script RR_OddEvenRR_MergeSortTest
