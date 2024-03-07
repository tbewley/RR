function [D,index]=RC_CocktailSort(D,v,n)
% function [D,index]=RC_CocktailSort(D,v,n)
% Reorder a matrix D based on the elements in its first column using a cocktail sort.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 7.1.3.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap07">Chapter 7</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_InsertionSort, RC_BlockInsertionSort, RC_MergeSort, RC_QuickSort, RC_HeapSort,
% RC_BitonicSort, RC_OddEvenRC_MergeSort.  Verify with RC_CocktailSortTest.

n=size(D,1); if nargout==2, D=[D, [1:n]']; end, l=1; r=n;
while r>l
  b=l; for i=l:r-1, if D(i,1)>D(i+1,1), D(i:i+1,:)=[D(i+1,:); D(i,:)]; b=i; end
    if v, plot(D(:,1),'x'); axis([0 n+1 -1 1]); hold on;
      plot([i i],[-1 1],'r-',[i+1 i+1],[-1 1],'b-');
      plot([l l],[-0.99 1],'g-',[r r],[-0.99 1],'c-'); hold off; pause(0.1); end
  end, r=b; if r<=l, break; end
  a=r; for i=r-1:-1:l, if D(i,1)>D(i+1,1), D(i:i+1,:)=[D(i+1,:); D(i,:)]; a=i; end
    if v, plot(D(:,1),'x'); axis([0 n+1 -1 1]); hold on;
	  plot([i i],[-1 1],'r-',[i+1 i+1],[-1 1],'b-');
	  plot([l l],[-0.99 1],'g-',[r r],[-0.99 1],'c-'); hold off; pause(0.1); end
  end, l=a+1;
end
if nargout==2, index=round(D(:,end)); D=D(:,1:end-1); end
end % function RC_CocktailSort
