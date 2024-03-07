function RK4(verbose,RHS,SimInit,SimPlot)            % Numerical Renaissance Codebase 1.0
% This function simulates y'=f(y) [implemented in RHS.m] using classical RK4.
[h,T,y,p]=SimInit(verbose); t=0;
for n=1:T/h
  k1=RHS(y,p); k2=RHS(y+(h/2)*k1,p); k3=RHS(y+(h/2)*k2,p); k4=RHS(y+h*k3,p);
  ynew=y+(h/6)*k1+(h/3)*(k2+k3)+(h/6)*k4; tnew=t+h;
  if verbose SimPlot(y,ynew,t,tnew,h,h,verbose); end, y=ynew; t=tnew;
end
end % function RK4.m