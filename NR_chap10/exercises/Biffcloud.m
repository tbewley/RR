function Biffcloud                                   % Numerical Renaissance Codebase 1.0
% This function simulates the Lorenz equation using RK4.
% ---------- Initialize the simulation paramters (user input)  ----------
clear all;  h=0.02;  TimeSteps=150;  paths=200;
yinitial=[8.75; 5.272; 6.672];  yinc=[0.05; 0.025; 0.025];
% --------------------------- end user input ---------------------------- 
figure(1);figure(2);clf(1);clf(2);
for path=1:paths
  f=(rand-0.5)*10
  y = yinitial + .05*f*yinc;
  figure(2); t=0;
  for TimeStep=1:TimeSteps
    k1=Computef(y);
    k2=Computef(y+(h/2)*k1);
    k3=Computef(y+(h/2)*k2);
    k4=Computef(y+h*k3);
    ynew=y+(h/6)*k1+(h/3)*(k2+k3)+(h/6)*k4;
    t=t+h;
    if t>1.1, plot3([y(1) ynew(1)],[y(2) ynew(2)],[y(3) ynew(3)],'b-');   hold on;  end
    y=ynew; 
  end  
  hold on; axis([-40 40 -40 40 -40 40]); view(-45,30);
  figure(1);  plot([y(1) ynew(1)],[y(2) ynew(2)],'x'); hold on;
end
end % function Biffcloud.m

function f=Computef(y)
  sigma=4; b=1; r=48;  % set the Lorenz parameters here.
  f=[sigma*(y(2)-y(1));  -y(2)-y(1)*y(3);  -b*y(3)+y(1)*y(2)-b*r];
end
