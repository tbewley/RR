function RC_MergeSortVerbose(a,b)                       % Numerical Renaissance Codebase 1.0
global D n speed frame
if b-a > 0
  b1 = a + floor((b-a)/2); a1=b1+1; RC_MergeSortVerbose(a,b1), RC_MergeSortVerbose(a1,b)
  while b1-a >= 0 & b-a1 >= 0
    if D(a1,1) < D(a,1); D(a:a1,:)=[D(a1,:); D(a:a1-1,:)]; 
      plot(D(:,1),'x'); axis([0 n+1 -1 1]);
      fn=['MSt/f' num2str(frame) '.tiff']; print('-dtiff','-r100',fn);
      fn=['MSe/f' num2str(frame) '.eps'];  print('-depsc',fn);   frame=frame+1;  pause(1/speed);
      a1=a1+1; b1=b1+1; 
    end;
    a=a+1;
  end
end
end % function RC_MergeSortVerbose