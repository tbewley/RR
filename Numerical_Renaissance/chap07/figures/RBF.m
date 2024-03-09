clear; close all
x=0:.01:1.2;
y1=x.^1;
y2=x.^2.*log(x);
y3=x.^3;
y4=x.^4.*log(x);
y5=x.^5;
y6=x.^6.*log(x);
y7=x.^7;
plot(x,y1,'k--'); hold on;
plot(x,y2,'k--');
plot(x,y3,'k--');
plot(x,y4,'k-.');
plot(x,y5,'k-.');
plot(x,y6,'k-');
plot(x,y7,'k-'); axis([0 1.2 -0.25 2.0001]);
