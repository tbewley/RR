function [D,index]=RC_MergeSort(D,v,a,b)
% function [D,index]=RC_MergeSort(D,v,a,b)
% Reorder a matrix D based on the elements in its first column using a merge sort.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_InsertionSort, RC_BlockInsertionSort, RC_QuickSort, RC_HeapSort, RC_CocktailSort,
% RC_BitonicSort, RC_OddEvenRC_MergeSort.  Verify with RC_MergeSortTest.

if nargout==2, D=[D, [1:size(D,1)]']; end, if nargin==3, b=a; a=1; end
if b-a > 0
  b1 = a + floor((b-a)/2); a1=b1+1; D=RC_MergeSort(D,v,a,b1); D=RC_MergeSort(D,v,a1,b);
  while b1-a >= 0 & b-a1 >= 0
    if D(a1,1) < D(a,1); D(a:a1,:)=[D(a1,:); D(a:a1-1,:)];
      if v, plot(D(:,1),'x'), pause(0.1), end
      a1=a1+1; b1=b1+1; end; a=a+1;
end; end
if nargout==2, index=round(D(:,end)); D=D(:,1:end-1); end
end % function RC_MergeSort
