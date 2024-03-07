global D n speed frame                               % Numerical Renaissance Codebase 1.0
n=49; speed=100;
 % !rm ISt/* ISe/* BSt/* BSe/* QSt/* QSe/* MSt/* MSe/* HSt/* HSe/* 
for i=0:4 
  frame=10000;
  D=2*rand(n,1)-1; plot(D(:,1),'x'); pause(10/speed);
  switch mod(i,5) 
    case 0, RC_InsertionSortVerbose;
    case 1, RC_BlockInsertionSortVerbose;
    case 2, RC_QuickSortVerbose(1,n);
    case 3, RC_MergeSortVerbose(1,n);
    case 4, RC_HeapSortVerbose;
  end
  plot(D(:,1),'x'); axis([0 n+1 -1 1]); hold off; pause(10/speed);
 % switch mod(i,5) 
 %   case 0, 
 %     fn=['ISt/f' num2str(frame) '.tiff']; print('-dtiff','-r100',fn);
 %     fn=['ISe/f' num2str(frame) '.eps'];  print('-depsc',fn); pause(1/speed);
 %   case 1, 
 %     fn=['BSt/f' num2str(frame) '.tiff']; print('-dtiff','-r100',fn);
 %     fn=['BSe/f' num2str(frame) '.eps'];  print('-depsc',fn); pause(1/speed);
 %   case 2,
 %     fn=['QSt/f' num2str(frame) '.tiff']; print('-dtiff','-r100',fn);
 %     fn=['QSe/f' num2str(frame) '.eps'];  print('-depsc',fn); pause(1/speed);
 %   case 3, 
 %     fn=['MSt/f' num2str(frame) '.tiff']; print('-dtiff','-r100',fn);
 %     fn=['MSe/f' num2str(frame) '.eps'];  print('-depsc',fn); pause(1/speed);
 %   case 4, 
 %     fn=['HSt/f' num2str(frame) '.tiff']; print('-dtiff','-r100',fn);
 %     fn=['HSe/f' num2str(frame) '.eps'];  print('-depsc',fn); pause(1/speed);
 % end
end
% Execute the following manually on the command line to assemble a movie:
% convert -loop 1000 -delay 10 ISt/f*.tiff ISt/movie.gif; convert -loop 1000 -delay 10 BSt/f*.tiff BSt/movie.gif; convert -loop 1000 -delay 10 QSt/f*.tiff QSt/movie.gif;
% convert -loop 1000 -delay 10 MSt/f*.tiff MSt/movie.gif; convert -loop 1000 -delay 10 HSt/f*.tiff HSt/movie.gif
