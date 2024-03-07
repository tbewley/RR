function RC_HeapSortVerbose                             % Numerical Renaissance Codebase 1.0
global D n speed frame
for a=floor(n/2):-1:1, Sift(a,n); end;
for b=n:-1:2, 
    D([1 b],:)=D([b 1],:);
    plot(D(:,1),'x'); axis([0 n+1 -1 1]); 
    fn=['HSt/f' num2str(frame) '.tiff']; print('-dtiff','-r100',fn);
    fn=['HSe/f' num2str(frame) '.eps'];  print('-depsc',fn);   frame=frame+1;  pause(1/speed);
   Sift(1,b-1); end
end % function RC_HeapSort
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Sift(a,b)
global D n speed frame
while a*2<=b
  c=a*2; if c<b & D(c,1) < D(c+1,1); c=c+1; end
  if D(a,1) < D(c,1);
    D([a c],:)=D([c a],:);
    plot(D(:,1),'x'); axis([0 n+1 -1 1]); 
    fn=['HSt/f' num2str(frame) '.tiff']; print('-dtiff','-r100',fn);
    fn=['HSe/f' num2str(frame) '.eps'];  print('-depsc',fn);   frame=frame+1;  pause(1/speed);
    a=c;
  else, return; end
end
end % function Sift