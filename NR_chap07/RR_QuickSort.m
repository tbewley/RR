function [D,index]=RC_QuickSort(D,v,i,k) 
% function [D,index]=RC_QuickSort(D,v,i,k)
% Reorder a matrix D based on the elements in its first column using a quick sort.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_InsertionSort, RC_BlockInsertionSort, RC_MergeSort, RC_HeapSort, RC_CocktailSort,
% RC_BitonicSort, RC_OddEvenRC_MergeSort.  Verify with RC_QuickSortTest.

if nargout==2, D=[D, [1:size(D,1)]']; end, if nargin==3, k=i; i=1; end
if k>i  % Begin by identifying a pivot.  Take the median of i=left, j=middle, and k=right.
  j=i+floor((k-i)/2);  a=D(i,1);  b=D(j,1);  c=D(k,1); 
  if a>b, if b>c, pivot=j; elseif a>=c, pivot=k; else, pivot=i; end;
  else    if b<c, pivot=j; elseif c>=a, pivot=k; else, pivot=i; end; end
  if     pivot==j; D([j k],:)=D([k j],:);                 % Store pivot at right, for now.
  elseif pivot==i; D([i k],:)=D([k i],:); end; 
  value=D(k,1); pivot=i; % Now scan from i to k-1 to determine new pivot value, separating
  for l=i:k-1,           % the entries below and above the specified pivot value.
    if v, a=i-.5; fill([a k k a],[-1 -1 1 1],'y'), hold on
      plot([a k],[value value],'r-',[pivot pivot],[-1 1],'g-',[l l],[-1 1],'r-')
      plot(D(:,1),'x'), hold off, pause(0.1), end
    if D(l,1) <= value; D([pivot l],:)=D([l pivot],:);  pivot=pivot+1; end
  end
  if v, a=i-.5; fill([a k k a],[-1 -1 1 1],'y'), hold on
    plot([a k],[value value],'r-',[pivot pivot],[-1 1],'g-',[l l],[-1 1],'r-')
    plot(D(:,1),'x'), hold off, pause(0.1), end
  D([k pivot],:)=D([pivot k],:);           % Move pivot (stored at k) to where it belongs.
  D=RC_QuickSort(D,v,i,pivot-1); D=RC_QuickSort(D,v,pivot+1,k); % Sort to left & right of pivot.
end
if nargout==2, index=round(D(:,end)); D=D(:,1:end-1); end
end % function Quicksort
