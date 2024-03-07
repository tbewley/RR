function RC_CocktailSortVerbose                         % Numerical Renaissance Codebase 1.0
n=49; n1=25; D=0.85*([1:n]'-n1)/n1+0.15*(2*rand(n,1)-1); D([1 n])=D([n 1]);
n=size(D,1); speed=1000; frame=1000;  l=1; r=n; figure(1); clf;
while r>l
  b=l; for i=l:r-1,
	  if D(i,1)>D(i+1,1), D(i:i+1,:)=[D(i+1,:); D(i,:)]; b=i; end
      plot(D(:,1),'x'); axis([0 n+1 -1 1]); hold on;
	  plot([i i],[-1 1],'r-',[i+1 i+1],[-1 1],'b-');
	  plot([l l],[-0.99 1],'g-',[r r],[-0.99 1],'c-'); hold off;
      fn=['CSt/f' num2str(frame) '.tiff']; print('-dtiff','-r100',fn);
      fn=['CSe/f' num2str(frame) '.eps'];  print('-depsc',fn);   frame=frame+1; 
	  pause(1/speed);  
  end; r=b;
  if r<=l, break; end
  a=r; for i=r-1:-1:l,
      if D(i,1)>D(i+1,1), D(i:i+1,:)=[D(i+1,:); D(i,:)]; a=i; end
      plot(D(:,1),'x'); axis([0 n+1 -1 1]); hold on;
	  plot([i i],[-1 1],'r-',[i+1 i+1],[-1 1],'b-');
	  plot([l l],[-0.99 1],'g-',[r r],[-0.99 1],'c-'); hold off;
      fn=['CSt/f' num2str(frame) '.tiff']; print('-dtiff','-r100',fn);
      fn=['CSe/f' num2str(frame) '.eps'];  print('-depsc',fn);   frame=frame+1; 
	  pause(1/speed);  
  end; l=a+1;
end
end % function RC_CocktailSortVerbose