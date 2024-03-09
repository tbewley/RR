function SimPlot_PredatorPrey(y,ynew,t,tnew,h,hnew,v)
% Numerical Renaissance Codebase 1.0
figure(1); plot([y(1) ynew(1)],[y(2) ynew(2)]);
figure(2); subplot(2,1,1); plot([t tnew],[y(1) ynew(1)]);
           subplot(2,1,2); plot([t tnew],[y(2) ynew(2)]);
if v==2, figure(2); plot([t, tnew],[h hnew]); end; pause(0.001);
end % function SimPlot_PredatorPrey.m
