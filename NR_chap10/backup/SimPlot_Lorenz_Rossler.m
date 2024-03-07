function SimPlot_Lorenz_Rossler(y,yn,t,tn,h,hn,v)    % Numerical Renaissance Codebase 1.0
figure(1), plot3([y(1) yn(1)],[y(2) yn(2)],[y(3) yn(3)]), hold on
if v==2, figure(2), plot([t, tn],[h hn]), hold on, end, pause(0.01),
end % function SimPlot_Lorenz_Rossler.m
