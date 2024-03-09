function Lorenz_RK45
% This function simulates the Lorenz equation using RK4/5.
% ---------- Initialize the simulation paramters (user input)  ----------
clear all;  h_initial=0.01;  T=20;  epsilon=.01;  y=[2;-2;-2];
% --------------------------- end user input ---------------------------- 
close all; figure(1); plot3([y(1)],[y(2)],[y(3)]); hold on;
axis([-23 23 -23 23 -23 23]);  view(-45,30);  format compact
figure(2); h=h_initial; t=0; plot(h,t); hold on;
while t<T,
  yold=y; told=t; h_old=h;
  ha=h;  hb=h/2;
  k1=Computef(y);             % calculate ya using RK4 with timestep h
  k2=Computef(y+(ha/2)*k1);   % [ Computef.m defined in Algorithm 11.1 ]
  k3=Computef(y+(ha/2)*k2);
  k4=Computef(y+ha*k3);
  ya=y+(ha/6)*k1+(ha/3)*(k2+k3)+(ha/6)*k4;
  k1=Computef(y);             % calculate yb using RK4 with timestep h/2
  k2=Computef(y+(hb/2)*k1);
  k3=Computef(y+(hb/2)*k2);
  k4=Computef(y+hb*k3);
  y=y+(hb/6)*k1+(hb/3)*(k2+k3)+(hb/6)*k4;
  k1=Computef(y);
  k2=Computef(y+(hb/2)*k1);
  k3=Computef(y+(hb/2)*k2);
  k4=Computef(y+hb*k3);
  y=y+(hb/6)*k1+(hb/3)*(k2+k3)+(hb/6)*k4; % (store yb in y)
  delta = norm(ya - y,1)/15; % estimate error of y=yb and use that to
  y=y*16/15-ya/15;           % calculate y=yc using fifth-order formula
  t=t+h;  h=h*(h*epsilon/(T*delta))^(1/4); % update h
  figure(1); plot3([yold(1) y(1)],[yold(2) y(2)],[yold(3) y(3)]); 
  figure(2); plot([told, t],[h_old h]);   pause(0.01);
end;  
end % function Lorenz_RK45.m
