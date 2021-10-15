% The Mobile Inverted Pendulum (MIP) Control Problem, solved in the Successive Loop Closure
% (SLC) framework using classical control techniques in the preferred SLC formulation
% (with theta closed on inner loop, and phi closed on outer loop), with simplified
% constants as suggested in the UCSD MAE143b S2 2013 final exam (version 1)

clear; k1=100, k2=1, z1=10
p(1)=-10; p(2)=-1; p(3)=10; p,  disp('den_G1=[s-p(1)][s-p(2)][s-p(3)]; note signs!')

% Set up plant
numG1=[k1 0]; denG1=PolyConv([1 -p(1)],[1 -p(2)],[1 -p(3)]);
numG2=-k2*PolyConv([1 -z1],[1 z1]); denG2=[1 0 0];

% Set up various controllers for problem #1:
numD1 = 3*PolyConv([1 10],[1 1]);  denD1 =PolyConv([1 20], [1 0]);
numD1a=40*PolyConv([1 10],[1 1]);  denD1a=PolyConv([1 100],[1 0]);
numD1b= 3*PolyConv([1 10],[1 1]);  denD1b=PolyConv([1 20], [1 .05]);

% Problem #1a
close all; figure(1); g.K=logspace(-1.5,1.5,400); g.axes=[-22 12 -16 16];
RLocus(numG1,denG1,numD1,denD1,g);
% print -depsc figs/final_143b_13_1a.eps

% Problem #1b
figure(2); g.omega=logspace(-1.5,2.5,400); g.line=0;
g.style='k-';  Bode(numG1,denG1,g); hold on;
g.style='b-';  Bode(PolyConv(numG1,numD1),PolyConv(denG1,denD1),g);
g.style='r--'; Bode(PolyConv(numG1,numD1a),PolyConv(denG1,denD1a),g);
g.style='m-.'; Bode(PolyConv(numG1,numD1b),PolyConv(denG1,denD1b),g);
subplot(2,1,1); axis([10^(-1.5) 10^(2.5) 10^(-2.5) 10^(1)])
subplot(2,1,2); axis([10^(-1.5) 10^(2.5) -180 -90]);
% print -depsc figs/final_143b_13_1b.eps

% Problem #1c
numH1 =PolyConv(numG1,numD1);  denH1 =PolyAdd(PolyConv(numG1,numD1), PolyConv(denG1,denD1));
numH1a=PolyConv(numG1,numD1a); denH1a=PolyAdd(PolyConv(numG1,numD1a),PolyConv(denG1,denD1a));
numH1b=PolyConv(numG1,numD1b); denH1b=PolyAdd(PolyConv(numG1,numD1b),PolyConv(denG1,denD1b));

% Problem #1d
P=denH1(end-1)/numH1(end-1);  Pa=denH1a(end-1)/numH1a(end-1);  Pb=P;

% Problem #1e
g.T=1.2; g.h=0.01; g.styleu='k-'; figure(3)
g.styley='b-';  ResponseTF(P*numH1,  denH1, 1,g); hold on; axis([0 1.2 0 1.4]);
g.styley='r--'; ResponseTF(Pa*numH1a,denH1a,1,g); hold on;
g.styley='m-.'; ResponseTF(Pb*numH1b,denH1b,1,g);
% print -depsc figs/final_143b_13_1e.eps

% Set up various controllers for problem #2:
numD2 = (11/111)*[1 10/11];  denD2 =[1 10];
numD2a = 0.032*[1 0.316];    denD2a =[1 3.16];

% Problem #2a
figure(4); g.K=logspace(-1.5,3,800); g.axes=[-16 12 -14 14];
RLocus(numG2,denG2,numD2,denD2,g);
% print -depsc figs/final_143b_13_2a.eps

% Problem #2b
figure(5); g.omega=logspace(-2.5,2.5,400); g.line=0;
g.style='k-';  Bode(numG2,denG2,g); hold on;
g.style='b-';  Bode(PolyConv(numG2,numD2), PolyConv(denG2,denD2),g);
g.style='r--'; Bode(PolyConv(numG2,numD2a),PolyConv(denG2,denD2a),g);
subplot(2,1,1); axis([10^(-2.5) 10^(2.5) 10^(-2) 10^(4)])
subplot(2,1,2); axis([10^(-2.5) 10^(2.5) -180 -90]);
% print -depsc figs/final_143b_13_2b.eps

% Problem #2c
numH2 =PolyConv(numG2,numD2);  denH2 =PolyAdd(PolyConv(numG2,numD2), PolyConv(denG2,denD2));
numH2a=PolyConv(numG2,numD2a); denH2a=PolyAdd(PolyConv(numG2,numD2a),PolyConv(denG2,denD2a));

% Problem #2e
g.T=20; g.h=0.01; g.styleu='k-'; figure(6)
g.styley='b-';  ResponseTF(numH2,denH2,1,g),   hold on,
g.styley='r--'; ResponseTF(numH2a,denH2a,1,g),
% print -depsc figs/final_143b_13_2e.eps

% Problem #4b
numH2full=PolyConv(numG2,Pb*numH1b,numD2);
denH2full=PolyAdd(PolyConv(numG2,Pb*numH1b,numD2),PolyConv(denG2,denH1b,denD2));
numF1=100^2; denF1=[1 2*.707*100 100^2];
numF2=10^2;  denF2=[1 2*.707*10  10^2 ];
numH1bF=PolyConv(numG1,numD1b,denF1);
denH1bF=PolyAdd(PolyConv(numG1,numD1b,numF1),PolyConv(denG1,denD1b,denF1));
numH2fullF=PolyConv(numG2,Pb*numH1bF,numD2,denF2);
denH2fullF=PolyAdd(PolyConv(numG2,Pb*numH1bF,numD2,numF2),PolyConv(denG2,denH1bF,denD2,denF2));
figure(7), g.styley='b-';  ResponseTF(numH2full, denH2full, 1,g), hold on
           g.styley='r--'; ResponseTF(numH2fullF,denH2fullF,1,g),
% print -depsc figs/final_143b_13_4b.eps

% Problem #5
g.figs=8; g.eps=.1; g.R=1000;
g.figL=9; Nyquist(PolyConv(numG1,numD1),PolyConv(denG1,denD1),g); axis equal
% print -depsc figs/final_143b_13_5a.eps

g.figL=10; Nyquist(PolyConv(numG1,numD1/3),PolyConv(denG1,denD1),g); axis equal
% print -depsc figs/final_143b_13_5b.eps

% Problem #6
PolyInertia([1 10 100])