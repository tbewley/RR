function PlotRK(y,ynew,t,tnew,h,hnew,v)
figure(1); plot3([y(1) ynew(1)],[y(2) ynew(2)],[y(3) ynew(3)]); 
if v==2, figure(2); plot([told, t],[h_old h]); end; pause(0.01);
% end function PlotRK