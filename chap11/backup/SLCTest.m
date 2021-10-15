function SLCTest                                    % Numerical Renaissance Codebase 1.0
% Set up the physical properties of system
mc=1; mp=0.1; l=0.25; I=mp*l^2/3; G=9.8; b1=0.01; b2=0.05; format long;

% Set up the inverted pendulum problem in SLC form
c1=mp*l; c2=(mc+mp)*(I+mp*l^2)-mp^2*l^2; c3=(mc+mp)*b1+(I+mp*l^2)*b2;
c4=(mc+mp)*mp*G*l-b1*b2; c5=mp*G*l*b2; c6=(I+mp*l^2)/(mp*l);
numG1=[c1 0]; denG1=[c2 c3 -c4 -c5]; numG2=[c6 b1 -G]; denG2=[1 0 0];
G1_open_loop_zeros=Roots(numG1), G1_open_loop_poles=Roots(denG1)
G2_open_loop_zeros=Roots(numG2), G2_open_loop_poles=Roots(denG2)

% Set up necessary plotting variables
for i=1:4, figure(i), clf, end, g.verbose=0; g.omega=logspace(0,3,100);
g.fix=0; g.extra=0; g.K=logspace(-2,+2,2000); g.T=2; g.steprange=[0 g.T 0 2.1];

disp('Inner loop: Proportional feedback.'); K=100;
g.linestyle='k-'; g.locus=[-15 15 -30 30]; g.omega=logspace(-4,3,20000);
TestSystem(numG1,denG1,K,1,g)
figure(3); hold on; figure(1); print -depsc invpendiPlocus.eps; pause;

disp('Inner loop: Lead compensation (z<p).');
K=240; z=6.3; p=40; numD1=K*[1 z]; denD1=[1 p];
g.linestyle='b--'; g.omega=logspace(-4,3,400); g.locus=[-45 8 -30 30];
TestSystem(numG1,denG1,numD1,denD1,g);
figure(1); print -depsc invpendileadlocus.eps;
figure(2); subplot(2,1,1); axis([.0001 1000 .001 20]);
           subplot(2,1,2); axis([.0001 1000 -185 -85]); print -depsc invpendiBode.eps;
figure(3); print -depsc invpendistep.eps;
figure(4); subplot(2,1,1); axis([.0001 1000 .0005 30]);
           subplot(2,1,2); axis([.0001 1000 -190 10]); print -depsc invpendiclbode.eps;
pause; for i=1:4, figure(i), clf, end,

disp('Idealized outer loop: Proportional feedback.'); K=0.8;
g.T=5; g.steprange=[0 g.T 0 2.1]; g.omega=logspace(-3,3,1000);
g.linestyle='k-.'; g.locus=[-8 8 -8 8]; TestSystem(numG2,denG2,K,1,g)
figure(3); hold on; figure(1); print -depsc invpendoiPlocus.eps; pause; 

disp('Idealized outer loop: Proportional feedback with negative gain.'); K=-0.8;
g.linestyle='b--'; TestSystem(numG2,denG2,K,1,g)
figure(3); hold on; figure(1); print -depsc invpendoiPneglocus.eps; pause;
for i=1:4, figure(i), clf, end, g.steprange=[0 g.T -0.4 1.28]; 

disp('Idealized outer loop: Lead compensation (z<p) with negative gain.');
K=-0.8; z=.5; p=5.437; numD2=K*[1 z]; denD2=[1 p];
g.linestyle='b--'; TestSystem(numG2,denG2,numD2,denD2,g);
figure(3); hold on; figure(1); print -depsc invpendoileadneglocus.eps; pause;

disp('Full outer loop: Lead compensation (z<p) with negative gain.');
num=Conv(numG1,numD1); P=1/1.265; numH1=P*num;
den=Conv(denG1,denD1); num=[zeros(1,length(den)-length(num)) num]; denH1=num+den;
H1_closed_loop_zeros=Roots(numH1), H1_closed_loop_poles=Roots(denH1)
numG3=Conv(numH1,numG2); denG3=Conv(denH1,denG2);
g.linestyle='r-'; g.locus=[-20 15 -15 15]; g.extra=-360; TestSystem(numG3,denG3,numD2,denD2,g)
num=Conv(numG3,numD2); numH2=num;
den=Conv(denG3,denD2); num=[zeros(1,length(den)-length(num)) num]; denH2=num+den;
H2_closed_loop_zeros=Roots(numH2), H2_closed_loop_poles=Roots(denH2)
figure(1); print -depsc invpendofulllocus.eps;
figure(2); subplot(2,1,1); axis([.001 1000 .001 1000000]);
		   subplot(2,1,2); axis([.001 1000 -370 -110]); print -depsc invpendofullbode.eps;
figure(3); print -depsc invpendofullstep.eps;
figure(4); subplot(2,1,1); axis([.001 1000 .0005 3]);
           subplot(2,1,2); axis([.001 1000 -400 10]); 
end % function SLCTest