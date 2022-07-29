% Example_18_14

numG=[1]; denG=PolyConv([1 10],[1 -10]);
numD=380*[1 10]; denD=[1 20];

close all; figure(1); g.K=logspace(-1.5,3,400); g.axes=[-40 40 -40 40];
RLocus(numG,denG,numD,denD,g); print -depsc example_18_14a.eps

numL=PolyConv(numG,numD); denL=PolyConv(denG,denD);

figure(2); g.omega=logspace(0,2,400); g.line=0; g.style='b-';  Bode(numL,denL,g);

figure(3); [numT,denT]=Feedback(numL,denL);                  % Closed-loop System
P=PolyVal(denT,0)/PolyVal(numT,0);
g.T=1.5; g.h=.01; g.styleu='r--'; g.styley='k-'; ResponseTF(P*numT,denT,1,g)

h=.02; % Now transform to discrete time
[numGz,denGz]=C2Dzoh(numG,denG,h);
[numDz,denDz]=C2DTustin(numD,denD,h,13);

g.K=logspace(-1.5,3,400); g.axes=[-1.5 1.5 -1.5 1.5];
figure(4); RLocus(numGz,denGz,numDz,denDz,g); hold on; % zgrid;
r=1; c=0; w=c+r*exp(i*[0:pi/50:2*pi]); plot(real(w),imag(w),'b--') % Draw a simple circle
print -depsc example_18_14b.eps

d=h/2; numDelay=[d^2/12 -d/2 1]; denDelay=[d^2/12 d/2 1];
numGd=PolyConv(numG,numDelay); denGd=PolyConv(denG,denDelay);

figure(5); g.K=logspace(-1.5,4.5,300); g.axes=[-400 400 -400 400];
RLocus(numGd,denGd,numD,denD,g); print -depsc example_18_14c.eps

figure(6); g.K=logspace(-1.5,3,300); g.axes=[-40 40 -40 40];
RLocus(numGd,denGd,numD,denD,g); print -depsc example_18_14d.eps