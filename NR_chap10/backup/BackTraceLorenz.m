function Lorenz                                      % Numerical Renaissance Codebase 1.0
% This function simulates the Lorenz equation using RK4.
% ---------- Initialize the simulation paramters (user input)  ----------
clear all;  h=0.01;  TimeSteps=500;  y=[10.8399;    5.6211;  10.7784];
% --------------------------- end user input ---------------------------- 
clf; figure(1); plot3([y(1)],[y(2)],[y(3)]); hold on;
t=-5; axis([-50 50 -50 50 -50 50]);  view(-45,30);
t,y
for TimeStep=1:TimeSteps
  k1=Computef(y);
  k2=Computef(y+(h/2)*k1);
  k3=Computef(y+(h/2)*k2);
  k4=Computef(y+h*k3);
  ynew=y+(h/6)*k1+(h/3)*(k2+k3)+(h/6)*k4;
  plot3([y(1) ynew(1)],[y(2) ynew(2)],[y(3) ynew(3)],'k:'); pause(0.01);
  y=ynew;  t=t+h;
end;
t,y

h=-h;
for TimeStep=1:TimeSteps
  t,
  k1=Computef(y);
  k2=Computef(y+(h/2)*k1);
  k3=Computef(y+(h/2)*k2);
  k4=Computef(y+h*k3);
  ynew=y+(h/6)*k1+(h/3)*(k2+k3)+(h/6)*k4;
  plot3([y(1) ynew(1)],[y(2) ynew(2)],[y(3) ynew(3)],'r-'); pause(0.01);
  y=ynew; t=t+h;
end;

end % function Lorenz.m

function f=Computef(y)
  sigma=4; b=1; r=96;  % set the Lorenz parameters here.
  f=[sigma*(y(2)-y(1));  -y(2)-y(1)*y(3);  -b*y(3)+y(1)*y(2)-b*r];
end
