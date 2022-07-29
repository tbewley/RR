function LeadTest                                    % Numerical Renaissance Codebase 1.0

alpha=-1; m=1; pbar=sqrt(2*abs(alpha)*9.8); numG=[1/m]; denG=Conv([1 pbar],[1 -pbar]);
for i=1:4, figure(i), clf, end, g.verbose=0; g.omega=logspace(0,3,100); g.fix=0;
g.K=logspace(-2,+2,1000); g.locus=42*[-3.5 0.5 -2 2]; g.T=0.3; g.steprange=[0 g.T 0 2];

disp('Proportional feedback.');
K=2043;
g.linestyle='k-.'; g.omega=logspace(0,3,10000); TestSystem(numG,denG,K,1,g)
figure(3); hold on; figure(1); print -depsc cartunsPlocus.eps; pause;
												  
disp('Lead compensation (z<p).  Note: oscillation stabilized.');
K=2857; z=4.43; p=44.3; numD=K*[1 z]; denD=[1 p];
g.linestyle='b--'; g.omega=logspace(0,3,100); TestSystem(numG,denG,numD,denD,g)
figure(3); hold on; figure(1); print -depsc cartunslead1locus.eps; pause;

disp('Lead compensation (z<p).  Note: even better!');
K=6532; z=45/sqrt(10); p=45*sqrt(10); numD=K*[1 z]; denD=[1 p];
g.linestyle='r-'; g.K=logspace(-2,2,1000); TestSystem(numG,denG,numD,denD,g)
figure(1); print -depsc cartunslead2locus.eps
figure(2); subplot(2,1,1); axis([1 1000 .004 120]);  plot([45 45],[.001 1],   'k:');
           subplot(2,1,2); axis([1 1000 -185 -120]); plot([45 45],[-180 -120],'k:');
           print -depsc cartunsBode.eps
figure(3); print -depsc cartunsStep.eps
figure(4); subplot(2,1,1), axis([1 1000 .003 300]), subplot(2,1,2), axis([1 1000 -190 10])

end % function LeadTest
