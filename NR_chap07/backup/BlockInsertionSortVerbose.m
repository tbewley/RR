function RC_BlockInsertionSort                          % Numerical Renaissance Codebase 1.0
global D n speed frame
% This function reorders a matrix D based on sgn(D(:,1)), treating 0 as positive.
c=n; while c>1 & D(c,1)>=0; Draw(c,n,n); c=c-1; end; Draw(c,n,n); b=c-1; a=b;
if c>1, while a>0
  while b>0; if D(b,1)<0;  Draw(b,b,c); b=b-1; else; break; end; end; Draw(b,b,c); if b==1; a=b; else; a=b-1; end;
  while a>0; if D(a,1)>=0; Draw(a,b,c); a=a-1; else; break; end; end; Draw(a,b,c); if a<0; break; end;
  D(a+1:c,:)=[D(b+1:c,:); D(a+1:b,:)];  % do the swap
  Draw(c,a+c-b,a); pause(5/speed); c=a+c-b; b=a-1;
end, end
Draw(n,c,0); hold on;
end % function RC_BlockInsertionSort.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Draw(a,b,c)
global D n speed frame
a=a+.5; b=b+.5; c=c+.5;
fill([a b b a],[0 0 3 3],'y'); hold on;
if c~=a; fill([b c c b],[-3 -3 0 0],'g'); end;
plot([0.5 n+.5],[0 0],'r-',[a a],[-1 1],'b-'); hold on; plot(D(:,1),'x'); axis([0 n+1 -1 1]); hold off;
    fn=['BSt/f' num2str(frame) '.tiff']; print('-dtiff','-r100',fn);
    fn=['BSe/f' num2str(frame) '.eps'];  print('-depsc',fn);   frame=frame+1;  pause(1/speed);
end % function Draw
