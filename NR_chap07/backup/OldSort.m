function Sort(type)                                  % Numerical Renaissance Codebase 1.0
global D n speed
% This function reorders a matrix based on its first column, which is assumed to be real.
plot(D(:,1),'x'); pause(10/speed);    p1=n; p2=n; p3=n;   % initialize
if type==1             % block insertion sort based on sgn(D(:,1)), treating 0 as positive
  while p3>1 & D(p3,1)>=0; Block(p3,n,n);  p3=p3-1; end; Block(p3,n,n); p2=p3-1; p1=p2;
  if p3>1, while p1>0
    while p2>0; if D(p2,1)<0;  Block(p2,p2,p3); p2=p2-1; else; break; end; end; Block(p2,p2,p3); if p2==1; p1=p2; else; p1=p2-1; end;
    while p1>0; if D(p1,1)>=0; Block(p1,p2,p3); p1=p1-1; else; break; end; end; Block(p1,p2,p3); if p1<0; break; end;
    D(p1+1:p3,:)=[D(p2+1:p3,:); D(p1+1:p2,:)];  % do the swap
    Block(p3,p1+p3-p2,p1); pause(5/speed); p3=p1+p3-p2; p2=p1-1;
  end, end
  Block(n,p3,0);  pause(10/speed);
elseif type==2         % insertion sort based on D(:,1);
  while p1>1
    p1=p1-1; p2=p1+1; p3=n;
    while p2<p3-1; pn=p2 + floor((p3-p2)/2); LineABCD(pn,p1,p2,p3); if D(pn,1)<D(p1,1), p2=pn+1; else, p3=pn-1; end; end;
    while p2<=p3;                            LineABCD(p3,p1,p2,p3); if D(p1,1)<D(p3,1), p3=p3-1; else, p2=p2+2; end; end;
    D(p1:p3,:)=[D(p1+1:p3,:); D(p1,:)];
    plot(D(:,1),'x'); axis([0.5 n+.5 -1 1]); pause(5/speed)
  end
  plot(D(:,1),'x'); axis([0.5 n+.5 -1 1]); hold off; pause(10/speed);
elseif type==3          % quicksort based on D(:,1);
  RC_QuickSort(1,n);
  plot(D(:,1),'x'); axis([0.5 n+.5 -1 1]); hold off; pause(10/speed);
elseif type==4
  RC_MergeSort(1,n);
  plot(D(:,1),'x'); axis([0.5 n+.5 -1 1]); hold off; pause(10/speed);
elseif type==5
  RC_HeapSort;
  plot(D(:,1),'x'); axis([0.5 n+.5 -1 1]); hold off; pause(10/speed);
end
% end function Sort.m

function Block(p1,p2,p3)
global D n speed
a=p1+.5; b=p2+.5; c=p3+.5;
fill([a b b a],[0 0 3 3],'y'); hold on;
if c~=a; fill([b c c b],[-3 -3 0 0],'g'); end;
plot([0.5 n+.5],[0 0],'r-',[a a],[-1 1],'b-'); hold on; plot(D(:,1),'x'); axis([0.5 n+.5 -1 1]); hold off; pause(1/speed);
% end function Line

function LineAB(a,b)
global D n speed
plot([a a],[-1 1],'b-',[b b],[-1 1],'r-'); hold on;
plot(D(:,1),'x'); axis([0.5 n+.5 -1 1]); hold off; pause(1/speed);
% end function Line

function LineABCD(a,b,c,d)
global D n speed
plot([b b],[-1 1],'r-',[c c],[-1 1],'g-',[d d],[-1 1],'c-',[a a],[-1 1],'b-'); hold on;
plot(D(:,1),'x'); axis([0.5 n+.5 -1 1]); hold off; pause(1/speed);
% end function Line

function [left,right] = RC_QuickSort(left, right)  % This function is recursive.
global D n speed
if right > left
  middle = left + floor((right-left)/2);  a=D(left,1);  b=D(middle,1);  c=D(right,1); 
  if a>b, if b>c, pivot=middle; elseif a>=c, pivot=right; else, pivot=left; end;
  else    if b<c, pivot=middle; elseif c>=a, pivot=right; else, pivot=left; end; end
  if     pivot==middle; D([middle right],:)=D([right middle],:); 
  elseif pivot==left;   D([left   right],:)=D([right left  ],:);  end;
  
  value = D(right,1);                           % We pivot about the rightmost entry
  newpivot = left;                              % and scan from the left to order the 
  for i=left:right-1,                           % entries below and above the pivot value.
    plot([left right],[value value],'r-');  hold on; plot([newpivot newpivot],[-1 1],'g-');
    LineAB(right,i);
    if D(i,1) <= value        
      D([newpivot i],:)=D([i newpivot],:);  newpivot=newpivot+1;
    end
  end
  D([right newpivot],:)=D([newpivot right],:);  % move pivot to where it belongs
  RC_QuickSort(left, newpivot-1)
  RC_QuickSort(newpivot+1, right)
end
% end function Quicksort
         
function RC_MergeSort(left, right)
global D n speed
if right-left > 0
  rightA = left + floor((right-left)/2); leftB=rightA+1;
  RC_MergeSort(left,rightA)
  RC_MergeSort(leftB,right)
  while rightA-left >= 0 & right-leftB >= 0
    if D(leftB,1) < D(left,1)
      D(left:leftB,:)=[D(leftB,:); D(left:leftB-1,:)];  plot(D(:,1),'x');  pause(1/speed);
      leftB=leftB+1; rightA=rightA+1;
    end
    left=left+1;
  end
end
% end function RC_MergeSort
         
function RC_HeapSort
global D n speed
start = floor(n/2)-1;
while start >= 0;  Sift(start+1, n); start = start - 1;  end;
last = n;
while last > 1;    D([1 last],:) = D([last 1],:);  plot(D(:,1),'x');  pause(1/speed);  last = last-1; Sift(1, last);  end
% end function RC_HeapSort

function Sift(root, last)
global D n speed
while (root-1) * 2 + 1 <= last-1
  child = root * 2;
  if child < last  &  D(child,1) < D(child + 1,1);  child = child + 1;  end
  if D(root,1) < D(child,1);  D([root child],:) = D([child root],:); plot(D(:,1),'x');  pause(1/speed);  root = child; 
  else, return; end
end
% end function Sift

         