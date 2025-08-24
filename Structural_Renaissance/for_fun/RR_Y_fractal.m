% script RR_Y_fractal
% Draw a Y.  Put 2 smaller Ys on top of it.  Repeat.  :)
% Code written by Thomas Bewley, with inspiration from Zacharay Bewley, on Aug 23, 2025.
%% Renaissance Repository, https://github.com/tbewley/RR (Structural Renaissance, for_fun)
%% Copyright 2025 by Thomas Bewley, and published under the BSD 3-Clause LICENSE

clear,  figure(1); clf, hold on, draw_Y([0;0],1,0), 
axis equal, axis tight, axis off

function draw_Y(loc,scale,depth)
 shrink=0.5;
 plot([loc(1) loc(1)],[loc(2) loc(2)+scale/2],'k-')
 plot([loc(1) loc(1)-scale/2],[loc(2)+scale/2 loc(2)+scale],'k-')
 plot([loc(1) loc(1)+scale/2],[loc(2)+scale/2 loc(2)+scale],'k-')
 if depth<15
   draw_Y([loc(1)-scale/2; loc(2)+scale],scale*shrink,depth+1)
   draw_Y([loc(1)+scale/2; loc(2)+scale],scale*shrink,depth+1)
 end  
end
