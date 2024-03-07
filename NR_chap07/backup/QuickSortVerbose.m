function RC_QuickSortVerbose(i, k)                      % Numerical Renaissance Codebase 1.0
global D n speed frame
if k > i       
  % Begin by identifying a pivot.  We take the median of i=left, j=middle, and k=right.
  j=i+floor((k-i)/2);  a=D(i,1);  b=D(j,1);  c=D(k,1);  
  if a>b, if b>c, pivot=j; elseif a>=c, pivot=k; else, pivot=i; end;
  else    if b<c, pivot=j; elseif c>=a, pivot=k; else, pivot=i; end; end
  if     pivot==j; D([j k],:)=D([k j],:);        % Store pivot at right, for now.
  elseif pivot==i; D([i k],:)=D([k i],:);  end;  
  value=D(k,1); pivot=i; % Now scan from i to k-1 to determine new pivot value, separating
  for l=i:k-1,           % the entries below and above the specified pivot value.
    a=i-.5; fill([a k k a],[-1 -1 1 1],'y'); hold on;
    plot([a k],[value value],'r-',[pivot pivot],[-1 1],'g-',[l l],[-1 1],'r-');  hold on;
    plot(D(:,1),'x'); axis([0 n+1 -1 1]); hold off;
    fn=['QSt/f' num2str(frame) '.tiff']; print('-dtiff','-r100',fn);
    fn=['QSe/f' num2str(frame) '.eps'];  print('-depsc',fn);   frame=frame+1;  pause(1/speed);
    if D(l,1) <= value; D([pivot l],:)=D([l pivot],:);  pivot=pivot+1; end
  end
  a=i-.5; fill([a k k a],[-1 -1 1 1],'y'); hold on;
  plot([a k],[value value],'r-',[pivot pivot],[-1 1],'g-',[l l],[-1 1],'r-');  hold on;
  plot(D(:,1),'x'); axis([0 n+1 -1 1]); hold off; 
  fn=['QSt/f' num2str(frame) '.tiff']; print('-dtiff','-r100',fn);
  fn=['QSe/f' num2str(frame) '.eps'];  print('-depsc',fn);   frame=frame+1;  pause(1/speed);
  D([k pivot],:)=D([pivot k],:);   % Move pivot (stored at k) to where it belongs.
  RC_QuickSortVerbose(i,pivot-1); RC_QuickSortVerbose(pivot+1,k)    % Sort to the left and right of new pivot.
end
end % function RC_QuickSortVerbose