function Bifflinearcloud                             % Numerical Renaissance Codebase 1.0
% ---------- Initialize the simulation paramters (user input)  ----------
clear all;  h=0.01;  TimeSteps=300;  paths=40;
yinitial=[8.75; 5.272; 6.672];

figure(1);figure(2);clf(1);clf(2);
for path=1:paths
  y = yinitial + .001*randn(3,1);
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

return

y = yinitial + .001*randn(3,1);
figure(2); t=0;
for TimeStep=1:TimeSteps
    ysave(:,TimeStep)=y;
    k1=Computef(y);
    k2=Computef(y+(h/2)*k1);
    k3=Computef(y+(h/2)*k2);
    k4=Computef(y+h*k3);
    ynew=y+(h/6)*k1+(h/3)*(k2+k3)+(h/6)*k4;
    t=t+h;
    if t>1.1, plot3([y(1) ynew(1)],[y(2) ynew(2)],[y(3) ynew(3)],'c-');   hold on;  end
    y=ynew; 
end  
ysave(:,TimeStep+1)=y;
figure(1);  plot([y(1) ynew(1)],[y(2) ynew(2)],'co'); hold on;


for path=1:paths/2
  yp = 0 + .001*randn(3,1);  y=yinitial;
  figure(2); t=0;
  for TimeStep=1:TimeSteps
    k1=ComputeAyp(yp,ysave(:,TimeStep));
    k2=ComputeAyp(yp+(h/2)*k1,(ysave(:,TimeStep)+ysave(:,TimeStep+1))/2);
    k3=ComputeAyp(yp+(h/2)*k2,(ysave(:,TimeStep)+ysave(:,TimeStep+1))/2);
    k4=ComputeAyp(yp+h*k3,ysave(:,TimeStep+1));
    ypnew=yp+(h/6)*k1+(h/3)*(k2+k3)+(h/6)*k4;
    t=t+h;
    ynew=ysave(:,TimeStep+1)+ypnew;
    if t>1.1 & path<5, plot3([y(1) ynew(1)],[y(2) ynew(2)],[y(3) ynew(3)],'k-');  end
    y=ynew;
    yp=ypnew; 
  end  
  figure(1);  plot([y(1) ynew(1)],[y(2) ynew(2)],'k*'); hold on;
end

end % function Bifflinearcloud.m

function f=Computef(y)
  sigma=4; b=1; r=48;  % set the Lorenz parameters here.
  f=[sigma*(y(2)-y(1));  -y(2)-y(1)*y(3);  -b*y(3)+y(1)*y(2)-b*r];
end

function f=ComputeAyp(yp,y)
  sigma=4; b=1; r=48;  % set the Lorenz parameters here.
  f=[sigma*(yp(2)-yp(1));  -yp(2)-y(1)*yp(3)-yp(1)*y(3);  -b*yp(3)+yp(1)*y(2)+y(1)*yp(2)];
end
