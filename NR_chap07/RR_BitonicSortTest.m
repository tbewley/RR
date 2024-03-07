% script <a href="matlab:RR_BitonicSortTest">RR_BitonicSortTest</a>
% Test <a href="matlab:help RR_BitonicSort">RR_BitonicSort</a> on a random set of data.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

n=2^7; D=2*rand(n,1)-1; close all, plot(D(:,1),'x'), axis([1 n -1 1]), pause(0.5)
[D,index]=RR_BitonicSort(D,1,n);      plot(D(:,1),'x'), axis([1 n -1 1])

% end script RR_BitonicSortTest
