function [h,T,y,v]=InitRK
h=0.05;  T=200; v=1;          % Initialize simulation paramters
y=[0.4575;  0.7233; -0.5690; -0.0037; -0.1224; 0.4780];         
if v, figure(1); clf; end    % Initialize plots
% end function InitRK
