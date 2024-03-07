% script <a href="matlab:RC_SortComplexTest">RC_SortComplexTest</a>
% Test <a href="matlab:help RC_SortComplex">RC_SortComplex</a> on a random complex vector of data.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

n=6; D=randn(n,1)+i*randn(n,1)
[D,index]=RC_SortComplex(D,'absolute value',@RC_QuickSort)
[D,index]=RC_SortComplex(D,'real part',@RC_MergeSort)

% end script RC_SortComplexTest
