function Biff                                        % Numerical Renaissance Codebase 1.0
% This function simulates the Lorenz equation using RK4.
% ---------- Initialize the simulation paramters (user input)  ----------
clear all;  h=0.02;  TimeSteps=135; 
%yb=[5.2308;  11.066; -9.68];
%yr=[5.2306;  11.055; -9.68];
%yg=[5.2304;  11.044; -9.68];

yr =[8.8; 5.25;  6.65];
yg =[8.75; 5.275; 6.675];
yb =[8.7;  5.3;   6.7];


% --------------------------- end user input ---------------------------- 
figure(1);figure(2);
clf(1);clf(2);
figure(2); plot3([yb(1)],[yb(2)],[yb(3)]); hold on;
axis([-25 25 -25 25 -25 25]);  view(-45,30); t=0; m1=1; m2=1;
for TimeStep=1:TimeSteps
  k1b=Computef(yb);
  k2b=Computef(yb+(h/2)*k1b);
  k3b=Computef(yb+(h/2)*k2b);
  k4b=Computef(yb+h*k3b);
  ybnew=yb+(h/6)*k1b+(h/3)*(k2b+k3b)+(h/6)*k4b;

  k1r=Computef(yr);
  k2r=Computef(yr+(h/2)*k1r);
  k3r=Computef(yr+(h/2)*k2r);
  k4r=Computef(yr+h*k3r);
  yrnew=yr+(h/6)*k1r+(h/3)*(k2r+k3r)+(h/6)*k4r;

  k1g=Computef(yg);
  k2g=Computef(yg+(h/2)*k1g);
  k3g=Computef(yg+(h/2)*k2g);
  k4g=Computef(yg+h*k3g);
  ygnew=yg+(h/6)*k1g+(h/3)*(k2g+k3g)+(h/6)*k4g;

  t=t+h;
  figure(1);  if t>3
  subplot(3,1,1); plot([t-h t],[yb(1) ybnew(1)],'b-',[t-h t],[yr(1) yrnew(1)],'r-',[t-h t],[yg(1) ygnew(1)],'g-'); hold on;
  subplot(3,1,2);  plot([t-h t],[yb(2) ybnew(2)],'b-',[t-h t],[yr(2) yrnew(2)],'r-',[t-h t],[yg(2) ygnew(2)],'g-'); hold on;
  subplot(3,1,3);  plot([t-h t],[yb(3) ybnew(3)],'b-',[t-h t],[yr(3) yrnew(3)],'r-',[t-h t],[yg(3) ygnew(3)],'g-'); hold on;
  figure(2);    plot3([yb(1) ybnew(1)],[yb(2) ybnew(2)],[yb(3) ybnew(3)],'b-', ...
                      [yr(1) yrnew(1)],[yr(2) yrnew(2)],[yr(3) yrnew(3)],'r-', ...
                      [yg(1) ygnew(1)],[yg(2) ygnew(2)],[yg(3) ygnew(3)],'g-');   hold on;   

  yb=ybnew;  yr=yrnew;  yg=ygnew;
  if t*m1>4.2, m1=0, t, yb, yr, yg, end 
  if t*m2>5.9, m2=0, t, yb, yr, yg, end
end;  
end % function Biff.m

function f=Computef(y)
  sigma=4; b=1; r=48;  % set the Lorenz parameters here.
  f=[sigma*(y(2)-y(1));  -y(2)-y(1)*y(3);  -b*y(3)+y(1)*y(2)-b*r];
end
