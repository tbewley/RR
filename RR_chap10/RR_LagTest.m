function LagTest                                     % Numerical Renaissance Codebase 1.0

%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap10
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

zbar=0.99; pbar=0; numG=[1 zbar]; denG=[1 pbar];
for i=2:4, figure(i), clf, end, g.verbose=0; g.omega=logspace(-2,2,100);
g.K=logspace(-2,+2,100); g.locus=[-3.01 1 -2 2]; g.T=10; g.steprange=[0 g.T 0 2];

disp('Proportional feedback.');
K=1;
g.ls='b--'; TestSystem(numG,denG,K,1,g); figure(3); hold on; pause;

disp('Lag compensation (z>p). Note: faster step response!');
K=1; z=3; p=1; numD=K*[1 z]; denD=[1 p];
g.ls='r-'; TestSystem(numG,denG,numD,denD,g);

end % function LagTest
