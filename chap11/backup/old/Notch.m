function Notch                                       % Numerical Renaissance Codebase 1.0

pbar=1; numG=[1]; denG=[1 0 pbar^2];                        % Open loop system
RLocus(numG,denG,logspace(-2,2,100)',1,[-3 1 -2 2]); pause  % Proportional feedback
numH=K*numG; denH=denG+[zeros(1,size(denG,2)-size(numG,2)) K*numG];
figure(2); step(numG,denH,50); roots(denH),  pause
	   
	   
z=0.8; p=2.5; numD=[1 0 z^2]; denD=Conv([1 p],[1 p]);       % Notch compensation
numGD=Conv(numG,numD); denGD=Conv(denG,denD);
RLocus(numGD,denGD,logspace(-2,2,100)',2,[-3.01 1 -2 2]);

end % function Notch
