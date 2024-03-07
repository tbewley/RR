function [D,index]=RC_OddEvenRC_MergeSort(D,v,a,n)
% function [D,index]=RC_OddEvenRC_MergeSort(D,v,a,n)
% Reorder D based on the n=2^s elements in its first column using an odd/even merge sort.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 7.2.2.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap07">Chapter 7</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_InsertionSort, RC_BlockInsertionSort, RC_MergeSort, RC_QuickSort, RC_HeapSort, RC_CocktailSort,
% RC_BitonicSort.  Verify with RC_OddEvenRC_MergeSortTest.

if nargin==3, n=a; a=1; end, if nargout==2, D=[D, [1:n]']; end
if n>1, m=round(n/2);
  D=RC_OddEvenRC_MergeSort(D,v,a,m);
  if v, plot(D(:,1),'kx'), axis([1 size(D,1) -1 1]), pause(0.1), end
  D=RC_OddEvenRC_MergeSort(D,v,a+m,m);
  if v, plot(D(:,1),'kx'), axis([1 size(D,1) -1 1]), pause(0.1), end
  D=OddEvenMerge(D,a,n,1);
  if v, plot(D(:,1),'kx'), axis([1 size(D,1) -1 1]), pause(0.1), end
end
if nargout==2, index=round(D(:,end)); D=D(:,1:end-1); end
end % function RC_OddEvenRC_MergeSort
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function D=OddEvenMerge(D,a,n,r)   % r is the distance of elements to be compared
m=r*2; if m<n
  D=OddEvenMerge(D,a,n,m); D=OddEvenMerge(D,a+r,n,m);   % even and odd subsequences
  for i=a+r:m:a+n-r-1, j=i+r; if D(i,1)>D(j,1), D([i j],:)=D([j i],:); end, end
else  j=a+r;                  if D(a,1)>D(j,1), D([a j],:)=D([j a],:); end
end
end % function OddEvenMerge