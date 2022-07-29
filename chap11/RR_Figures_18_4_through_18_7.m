% script <a href="matlab:Figures_18_4_through_18_8">Figures_18_4_through_18_8</a>
% Illustrate how to use the fundamental tools of classical control design (that is,
% root locus, open-loop Bode, Nyquist, closed-loop Bode, and step response) on a
% representative control design problem, as considered in the text.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 18.1.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap18">Chapter 18</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.

close all;
numG=[1 .3]; denG=[1 12 20 0 0];    % Plant      = G(s) = (s+.3)/[s^2(s+2)(s+10)]
numD=15; denD=1;                    % Controller = D(s) = 15
numGD=PolyConv(numG,numD); denGD=PolyConv(denG,denD); % Open-loop System
[numH,denH]=Feedback(numGD,denGD);                    % Closed-loop System

g.K=logspace(-3.5,4,400); g.axes=[-3 1 -2 2];
g.omega=logspace(-2,3,100); g.line=1; g.style='k-';

figure(1), RLocus(numG,denG,numD,denD,g)                                                                             
figure(2), Bode(numGD,denGD,g)
figure(3), g.line=0; Bode(numH,denH,g)           
figure(4), g.T=15; g.h=.01; g.styleu='r--'; g.styley='k-'; ResponseTF(numH,denH,1,g) 
g.figs=5; g.figL=6; g.eps=.2; g.R=4; Nyquist(numGD,denGD,g)

% end script Figures_18_4_through_18_8
