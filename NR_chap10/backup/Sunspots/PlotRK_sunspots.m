function PlotRK(y,ynew,t,tnew,h,hnew,v)
figure(1); 
  subplot(6,1,1); plot([t tnew],[y(1) ynew(1)]); hold on;
  subplot(6,1,2); plot([t tnew],[y(2) ynew(2)]); hold on;
  subplot(6,1,3); plot([t tnew],[y(3) ynew(3)]); hold on;
  subplot(6,1,4); plot([t tnew],[y(4) ynew(4)]); hold on;
  subplot(6,1,5); plot([t tnew],[y(5) ynew(5)]); hold on;
  subplot(6,1,6); plot([t tnew],[y(6) ynew(6)]); hold on;
% end function PlotRK