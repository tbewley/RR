function RK45(verbose,RHS,SimInit,SimPlot)           % Numerical Renaissance Codebase 1.0
% This function simulates y'=f(y) [implemented in RHS.m] using RK4/5.
[h,T,y,p]=SimInit(verbose); t=0; epsilon=.01;
while t<T,
  ha=h;  hb=h/2;                           
  k1=RHS(y ,p); k2=RHS(y +(ha/2)*k1,p); k3=RHS(y +(ha/2)*k2,p); k4=RHS(y +ha*k3,p);
  ya=y +(ha/6)*k1+(ha/3)*(k2+k3)+(ha/6)*k4; % calculate ya using RK4 with timestep h
  k1=RHS(y ,p); k2=RHS(y +(hb/2)*k1,p); k3=RHS(y +(hb/2)*k2,p); k4=RHS(y +hb*k3,p);
  yb=y +(hb/6)*k1+(hb/3)*(k2+k3)+(hb/6)*k4; % calculate yb using RK4 with timestep h/2...
  k1=RHS(yb,p); k2=RHS(yb+(hb/2)*k1,p); k3=RHS(yb+(hb/2)*k2,p); k4=RHS(yb+hb*k3,p);
  yb=yb+(hb/6)*k1+(hb/3)*(k2+k3)+(hb/6)*k4; % ... finish calculating yb (two timesteps)
  delta = norm(ya - yb,1)/15;                    % estimate error of y=yb and use that to
  ynew=(yb*16-ya)/15;                            % calculate ynew using fifth-order formula
  tnew=t+h;  hnew=h*(h*epsilon/(T*delta))^(1/4); % update h based on error estimate
  if verbose SimPlot(y,ynew,t,tnew,h,hnew,verbose); end, y=ynew; t=tnew; h=hnew;
end  
end % function RK45.m
