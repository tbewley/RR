function [D,index]=RC_BitonicSort(D,v,n)
% function [D,index]=RC_BitonicSort(D,v,n)
% Reorder a matrix D based on the n=2^s elements in its first column using a bitonic sort.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_InsertionSort, RC_BlockInsertionSort, RC_MergeSort, RC_QuickSort, RC_HeapSort, RC_CocktailSort,
% RC_OddEvenRC_MergeSort.  Verify with RC_BitonicSortTest.

s=log2(n); if nargout==2, D=[D, [1:n]']; end
for stage=1:s, N=2^stage; Nsets=n/N;
  for level=stage:-1:1, Nl=2^level; Ngroups=N/Nl;
    for set=0:Nsets-1, t=(-1)^set; for group=0:Ngroups-1, for i=1:Nl/2
      % Determine each pair of elements to be compared, and compare them.
      a=i+N*set+Nl*group; b=a+Nl/2; if t*D(a,1)>t*D(b,1), D([a b],:)=D([b a],:); end
    end, end, end
    if v, plot(D(:,1),'kx'), axis([1 n -1 1]), pause(0.5), end
  end
  if v, plot(D(:,1),'bx'), axis([1 n -1 1]), pause(2), end
end
if nargout==2, index=round(D(:,end)); D=D(:,1:end-1); end
end % function RC_BitonicSort