function Lorenz                                      % Numerical Renaissance Codebase 1.0
% This function simulates the Lorenz equation using RK4.
% ---------- Initialize the simulation paramters (user input)  ----------
clear all;  h=0.02;  TimeSteps=500;  y=[-7.8657; 1.3039; 6.3850];
% --------------------------- end user input ---------------------------- 
clf; figure(1); clf;  figure(2); clf;
axis([-23 23 -23 23 -23 23]);  view(-45,30);
for TimeStep=1:TimeSteps
  k1=Computef(y);
  k2=Computef(y+(h/2)*k1);
  k3=Computef(y+(h/2)*k2);
  k4=Computef(y+h*k3);
  ynew=y+(h/6)*k1+(h/3)*(k2+k3)+(h/6)*k4;
  figure(1);
  plot([TimeStep TimeStep+1]*h,[y(1) ynew(1)]+30, ...
       [TimeStep TimeStep+1]*h,[y(2) ynew(2)], ...
       [TimeStep TimeStep+1]*h,[y(3) ynew(3)]-40); hold on;
  figure(2);
  plot3([y(1) ynew(1)],[y(2) ynew(2)],[y(3) ynew(3)]); hold on;
  pause(0.0001);
  y=ynew;
end;  y,  % print -deps lorenz.eps
end % function Lorenz

function f=Computef(y)
sigma=4; b=1; r=48;  % set the Lorenz parameters here.
f=[sigma*(y(2)-y(1));  -y(2)-y(1)*y(3);  -b*y(3)+y(1)*y(2)-b*r];
end % function Computef
