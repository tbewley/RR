function [h,T,y,p]=SimInit_Lorenz(v)                 % Numerical Renaissance Codebase 1.0
h=0.01; T=500; y=[1;1;0.01]; p.sigma=4; p.b=1; p.r=48; % Simulation and Lorenz paramters
if v==1, figure(1); clf; plot3([y(1)],[y(2)],[y(3)]); hold on  % Initialize plots
         axis([-23 23 -23 23 -23 23]); view(-45,30); end
if v==2; figure(2); clf; plot(0,h); hold on; end
end % function SimInit_Lorenz.m
