function [h,T,y,p]=SimInit_PredatorPrey(v)           % Numerical Renaissance Codebase 1.0
h=0.1;  T=500;  y=[0.3;0.2];             % Initialize simulation paramters
p.b=1;p.p=1;p.r=1;p.d=1;  % set the predator/prey model parameters here.
if v==1, figure(1); clf; plot([y(1)],[y(2)],'x'); hold on  % Initialize plots
         figure(2); clf; subplot(2,1,1); plot(0,y(1),'x'); hold on
                         subplot(2,1,2); plot(0,y(2),'x'); hold on
end
end % function SimInit_PredatorPrey.m
