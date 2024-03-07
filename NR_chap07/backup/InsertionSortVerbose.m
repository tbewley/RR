function RC_InsertionSortVerbose                        % Numerical Renaissance Codebase 1.0
global D n speed frame
% This function reorders a matrix based on its first column, which is assumed to be real.
for i=n-1:-1:1
  a=i+1; b=n;  
  % The following 2 lines search the ordered part of the list, [a,b], using a bisection
  % algorithm to find the appropriate point of insertion  for record i.
  while a<b-1; c=a+floor((b-a)/2); Draw(c,i,a,b); if D(c,1)<D(i,1), a=c+1; else, b=c-1; end; end;
  while a<=b;                      Draw(b,i,a,b); if D(i,1)<D(b,1), b=b-1; else, a=a+2; end; end;
  D(i:b,:)=[D(i+1:b,:); D(i,:)];    % Insert record i at the designated point.
  plot(D(:,1),'x'); axis([0 n+1 -1 1]); pause(5/speed)
end
end % function RC_InsertionSortVerbose.m
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Draw(c,i,a,b)
global D n speed frame
plot([i i],[-1 1],'r-',[a a],[-1 1],'g-',[b b],[-1 1],'c-',[c c],[-1 1],'b-'); hold on;
plot(D(:,1),'x'); axis([0 n+1 -1 1]); hold off; 
fn=['ISt/f' num2str(frame) '.tiff']; print('-dtiff','-r100',fn);
fn=['ISe/f' num2str(frame) '.eps'];  print('-depsc',fn);   frame=frame+1;  pause(1/speed);
end % function Draw