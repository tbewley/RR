function Lorenz
% This function simulates the Lorenz equation using RK4.
% ---------- Initialize the simulation paramters (user input)  ----------
clear all;  h=0.01;  TimeSteps=20000;  y=[2;-2;-2];
% --------------------------- end user input ---------------------------- 
clf; figure(1); plot3([y(1)],[y(2)],[y(3)]); hold on;
axis([-23 23 -23 23 -23 23]);  view(-45,30);
for TimeStep=1:TimeSteps
  k1=Computef(y);
  k2=Computef(y+(h/2)*k1);
  k3=Computef(y+(h/2)*k2);
  k4=Computef(y+h*k3);
  ynew=y+(h/6)*k1+(h/3)*(k2+k3)+(h/6)*k4;
  plot3([y(1) ynew(1)],[y(2) ynew(2)],[y(3) ynew(3)]); pause(0.01);
  y=ynew;
end;  print -deps lorenz.eps
end % function Lorenz.m

function f=Computef(y)
  sigma=4; b=1; r=48;  % set the Lorenz parameters here.
  f=[sigma*(y(2)-y(1));  -y(2)-y(1)*y(3);  -b*y(3)+y(1)*y(2)-b*r];
end
