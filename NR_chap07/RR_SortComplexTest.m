% script <a href="matlab:RR_SortComplexTest">RR_SortComplexTest</a>
% Test <a href="matlab:help RR_SortComplex">RR_SortComplex</a> on a random complex vector of data.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, published under BSD 3-Clause License. 

n=6; D=randn(n,1)+i*randn(n,1)
[D,index]=RR_SortComplex(D,'absolute value',@RR_QuickSort)
[D,index]=RR_SortComplex(D,'real part',@RR_MergeSort)

% end script RR_SortComplexTest
