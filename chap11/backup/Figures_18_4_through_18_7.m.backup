% TestRootLocusBode                                  % Numerical Renaissance Codebase 1.0
% Note, each num/den pair must be the same order in this simple code.
numG=[0 0 1]; denG=[1 0 -1];                   % Plant      = G(s) = 1/(s^2-1) 
numD=50*[1 1.1]; denD=[1 10];                  % Controller = D(s) = 50 (s+1.1)/(s+10)
numGD=conv(numG,numD);  denGD=conv(denG,denD); % G(s)*D(s)
numH=numGD; denH=(numGD+denGD);                % H(s)=D(s)*G(s)/[1+D(s)*G(s)]
figure(1); clf; RLocus(numGD,denGD,logspace(-1.5,0.2,500)',1);  % Root Locus Plot
figure(2); clf; Bode(numGD,denGD,logspace(-2,3,50));            % Open Loop Bode Plot
figure(3); clf; Bode(numH,denH,logspace(-2,2,50));              % Closed Loop Bode Plot
figure(5); clf; Nyquist(numGD,denGD,logspace(-2,3,50));         % Nyquist Plot
% figure(4); clf; Step(numH,denH,Tmax);                           % Closed Loop Bode Plot
% [A,B,C,D]=tf2ss(num,den)
% figure(4); clf; step(tf(numH,denH),5);
% end script TestRootLocusBode.m