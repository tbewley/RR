function NotchTest                                   % Numerical Renaissance Codebase 1.0

alpha=1; m=1; a=sqrt(2*alpha*9.8); numG=[1/m]; denG=PolyConv([1 sqrt(-1)*a],[1 -sqrt(-1)*a]);
for i=1:4, figure(i), clf, end, g.verbose=0; g.omega=logspace(-1,2,10000);
g.K=logspace(-2,2,100); g.locus=6*[-2 2 -2 2]; g.T=3; g.steprange=[0 g.T 0 3.7];

disp('Proportional feedback');
K=50;
g.linestyle='k-'; TestSystem(numG,denG,K,1,g), figure(1), % print -depsc cartoscPlocus.eps
pause; for i=1:1, figure(i), clf, end; figure(3); hold on;

disp('Lead compensation (z<p). Bad overshoot, but response not sensitive to value of pbar')
K=50; z=1; p=10; numD=K*[1 z]; denD=[1 p];
g.linestyle='b--'; TestSystem(numG,denG,numD,denD,g);
figure(1), % print -depsc cartoscleadlocus.eps,
figure(2), subplot(2,1,1), axis([.1 100 .006 300]), subplot(2,1,2), axis([.1 100 -190 80])
           % print -depsc cartoscleadBode.eps, 
figure(3), % print -depsc cartoscleadstep.eps
figure(4), subplot(2,1,1), axis([.1 100 .001 1000]), subplot(2,1,2), axis([.1 100 -190 50])
           % print -depsc cartoscleadclosedBode.eps;
pause; for i=1:4, figure(i), clf, end

disp('Notch (z<pbar).  Overshoot taken care of! :)')
K=98; z=4.37; p=8; numD=K*[1 0 z^2]; denD=PolyConv([1 p],[1 p]); 
g.omega=logspace(0,1,10000); g.T=3; g.steprange=[0 g.T 0 1.2]; g.K=logspace(-3,1,100);
g.linestyle='r-'; TestSystem(numG,denG,numD,denD,g), figure(3), hold on
Nyquist(PolyConv(numG,numD),PolyConv(denG,denD)),
figure(5), axis equal, axis tight, print -depsc cartoscNyquistContour.eps
figure(1), print -depsc cartoscnotchlocus.eps
figure(6), axis equal, axis tight, print -depsc cartoscStableNyquist.eps, pause

disp('Notch (z>pbar).  Overshoot still ok, but ...')
K=98; z=4.49; p=8; numD=K*[1 0 z^2]; denD=PolyConv([1 p],[1 p]); g.linestyle='b--';
TestSystem(numG,denG,numD,denD,g)      
Nyquist(PolyConv(numG,numD),PolyConv(denG,denD)), figure(6), print -depsc cartoscStableNyquist.eps
figure(2), subplot(2,1,1), axis([1 10 .099999 20]), subplot(2,1,2), axis([1 10 -190 140])
           print -depsc cartoscnotchBode.eps
figure(3), print -depsc cartoscnotchStep.eps
figure(6), axis equal, axis tight, print -depsc cartoscUnstableNyquist.eps, pause

disp('Notch (z<pbar, detail).  Note decaying wiggle in response.')
K=98; z=4.37; p=8; numD=K*[1 0 z^2]; denD=PolyConv([1 p],[1 p]); g.linestyle='r-'; g.T=50;
g.locus=[-.075 .075 4.35 4.45]; g.steprange=[0 g.T 0 1.1]; TestSystem(numG,denG,numD,denD,g)
pause; figure(1), set(gcf,'PaperPositionMode','auto'),  print -depsc cartoscnotchdetaillocus.eps
figure(3), hold on

disp('Notch (z>pbar, detail).  Growing wiggle in response! Problem!')
K=98; z=4.49; p=8; numD=K*[1 0 z^2]; denD=PolyConv([1 p],[1 p]); g.linestyle='b--';
g.locus=[-.075 .075 4.4 4.5]; TestSystem(numG,denG,numD,denD,g)
figure(1), print -depsc cartoscnotchdetaillocusuns.eps
figure(3), set(gcf,'PaperPositionMode','auto'), print -depsc cartoscnotchStepdetail.eps

end % function NotchTest
