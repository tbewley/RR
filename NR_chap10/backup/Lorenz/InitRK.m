function [h,T,y,v]=InitRK
h=0.01;  T=200;  y=[2;-2;-2]; v=1;        % Initialize simulation paramters
if v,                                     % Initialize plots
  figure(1); clf; plot3([y(1)],[y(2)],[y(3)]); hold on;
  axis([-23 23 -23 23 -23 23]); view(-45,30);
  if v>1;
    figure(2); clf; plot(t,h); hold on; 
end
% end function InitRK
