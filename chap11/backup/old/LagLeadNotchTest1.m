function LagLeadNotchTest1                            % Numerical Renaissance Codebase 1.0

disp('%%%%%%%%% System #2 (second-order, unstable cart) %%%%%%%%%'); 
alpha=-1; m=1; pbar=sqrt(2*abs(alpha)*9.8); numG=[1/m]; denG=Conv([1 pbar],[1 -pbar]);
for i=1:4, figure(i), clf, end; g.omega=logspace(0,3,100); g.locus=42*[-3.5 0.5 -2 2];

disp('Proportional feedback.');
K=2043;
g.linestyle='k-.'; g.T=0.3; g.steprange=[0 g.T 0 2]; g.K=logspace(-3,1,100)'; g.extraphase=-360; g.omega=logspace(0,3,10000);
TestSystem(numG,denG,K,1,g);
figure(3); hold on; figure(1); print -depsc cartunsPlocus.eps; pause;
												  
disp('Lead compensation (z<p).  Note: oscillation stabilized.');
K=2857; z=4.43; p=44.3; numD=K*[1 z]; denD=[1 p];
g.linestyle='b--'; g.K=logspace(-2,2,1000)'; g.extraphase=0; g.omega=logspace(0,3,100);
TestSystem(numG,denG,numD,denD,g);
figure(3); hold on; figure(1); print -depsc cartunslead1locus.eps; pause;

disp('Lead compensation (z<p).  Note: even better!');
K=6532; z=45/sqrt(10); p=45*sqrt(10); numD=K*[1 z]; denD=[1 p];
g.linestyle='r-'; g.K=logspace(-2,2,1000)';
TestSystem(numG,denG,numD,denD,g);  
figure(1); print -depsc cartunslead2locus.eps
figure(2); subplot(2,1,1); axis([1 1000 .001 120]);  plot([45 45],[.001 1],   'k:');
           subplot(2,1,2); axis([1 1000 -185 -120]); plot([45 45],[-180 -120],'k:'); print -depsc cartunsBode.eps	
figure(3); print -depsc cartunsStep.eps;
figure(4); subplot(2,1,1); axis([1 1000 .001 1000]); subplot(2,1,2); axis([1 1000 -190 10]); pause
		
disp('%%%%%%%%% System #3 (second-order, oscillatory cart)  %%%%%%%%%');
alpha=1; m=1; abar=sqrt(2*alpha*9.8), numG=[1/m]; denG=Conv([1 sqrt(-1)*abar],[1 -sqrt(-1)*abar]);
for i=1:4, figure(i), clf, end; g.omega=logspace(-1,2,1000); g.locus=5*[-2.5 1.5 -2 2];

disp('Proportional feedback');
K=50;
g.linestyle='k-.'; g.T=3; g.steprange=[0 g.T 0 3.7]; g.K=logspace(-3,1,100)';
TestSystem(numG,denG,K,1,g);
figure(1); print -depsc cartoscPlocus.eps; pause
for i=1:1, figure(i), clf, end; figure(3); hold on;

disp('Lead compensation (z<p).  Note: bad overshoot, but the solution is not sensitive to precise value of pbar');
K=50; z=1; p=10; numD=K*[1 z]; denD=[1 p];
g.linestyle='b--'; 
TestSystem(numG,denG,numD,denD,g);
figure(1); print -depsc cartoscleadlocus.eps; figure(3); print -depsc cartoscleadstep.eps; pause
for i=1:4, figure(i), clf, end


disp('Notch (z<pbar).  Overshoot taken care of! :)')
K=98; z=4.37; p=8; numD=K*[1 0 z^2]; denD=Conv([1 p],[1 p]);
g.linestyle='r-'; g.omega=logspace(0,1,10000); 
g.T=3;  g.steprange=[0 g.T 0 1.2]; g.locus=5*[-2.5 1.5 -2 2];     TestSystem(numG,denG,numD,denD,g)
figure(3); hold on;
Nyquist(Conv(numG,numD),Conv(denG,denD)); figure(5); print -depsc cartoscNyquistContour.eps; figure(6); print -depsc cartoscStableNyquist.eps; pause

disp('Notch (z>pbar).  Overshoot still ok, but ...')
K=98; z=4.49; p=8; numD=K*[1 0 z^2]; denD=Conv([1 p],[1 p]);
g.linestyle='b--'; g.omega=logspace(0,1,10000); 
TestSystem(numG,denG,numD,denD,g)      
Nyquist(Conv(numG,numD),Conv(denG,denD)); figure(6); print -depsc cartoscStableNyquist.eps; pause

figure(1); print -depsc cartoscnotchlocus.eps
figure(2); subplot(2,1,1); axis([1 10 .1 300]); subplot(2,1,2); axis([1 10 -185 140]);
		   print -depsc cartoscnotchBode.eps	
figure(3); print -depsc cartoscnotchStep.eps

disp('Notch (z<pbar, detail).  Note decaying wiggle in response.')
K=98; z=4.37; p=8; numD=K*[1 0 z^2]; denD=Conv([1 p],[1 p]);
g.linestyle='r-'; g.omega=logspace(0,1,10000); 
g.T=50; g.steprange=[0 g.T 0.9 1.1]; g.locus=[-.075 .075 4.35 4.45]; TestSystem(numG,denG,numD,denD,g)
Nyquist(Conv(numG,numD),Conv(denG,denD)); figure(6); print -depsc cartoscStableNyquistdetail.eps;
figure(1); set(gcf,'PaperPositionMode','auto');  print -depsc cartoscnotchdetaillocus.eps
figure(3); hold on; pause;

disp('Notch (z>pbar, detail).  Growing wiggle in response! Problem!  :(')
K=98; z=4.49; p=8; numD=K*[1 0 z^2]; denD=Conv([1 p],[1 p]);
g.linestyle='b--'; g.omega=logspace(0,1,10000); 
TestSystem(numG,denG,numD,denD,g)
Nyquist(Conv(numG,numD),Conv(denG,denD)); figure(6); print -depsc cartoscUnstableNyquistdetail.eps;

figure(1); print -depsc cartoscnotchdetaillocus.eps
figure(2); subplot(2,1,1); axis([1 10 .099999 100]); subplot(2,1,2); axis([1 10 -185 140]);
print -depsc cartoscnotchBodedetail.eps	
figure(3); set(gcf,'PaperPositionMode','auto'); print -depsc cartoscnotchStepdetail.eps

end % function LagLeadNotchTest1
