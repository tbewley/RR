function [D,index]=RC_InsertionSort(D,v,n)
% function [D,index]=RC_InsertionSort(D,v,n)
% Reorder a matrix D based on the elements in its first column using an insertion sort.
% Renaissance Codebase, https://github.com/tbewley/RC/NRchap07
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RC_BlockInsertionSort, RC_MergeSort, RC_QuickSort, RC_HeapSort, RC_CocktailSort,
% RC_BitonicSort, RC_OddEvenRC_MergeSort.  Verify with RC_InsertionSortTest.

if nargout==2; D=[D, [1:n]']; end, for i=n-1:-1:1, a=i+1; b=n;  
  % The following 2 lines search the ordered part of the list, [a,b], using a bisection
  % algorithm to find the appropriate point of insertion for record i.
  while a<b-1; c=a+floor((b-a)/2);
    if v, Draw(D,c,i,a,b,n), end
    if D(c,1)<D(i,1), a=c+1; else, b=c-1; end, end
  while a<=b;
    if v, Draw(D,b,i,a,b,n), end
    if D(i,1)<D(b,1), b=b-1; else, a=a+2; end, end
  D(i:b,:)=[D(i+1:b,:); D(i,:)];    % Insert record i at the designated point.
  if v, plot(D(:,1),'x'); axis([0 n+1 -1 1]); pause(0.1), end
end
if nargout==2, index=round(D(:,end)); D=D(:,1:end-1); end
end % function RC_InsertionSort
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Draw(D,c,i,a,b,n)
plot([i i],[-1 1],'r-',[a a],[-1 1],'g-',[b b],[-1 1],'c-',[c c],[-1 1],'b-'); hold on;
plot(D(:,1),'x'); axis([0 n+1 -1 1]); hold off; pause(0.1),
end % function Draw