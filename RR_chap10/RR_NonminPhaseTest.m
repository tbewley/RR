function SLCTest                                    % Numerical Renaissance Codebase 1.0

%% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

% Set up necessary plotting variables
for i=1:2, figure(i), clf, end, g.verbose=0;
g.fix=0; g.extra=0; g.K=logspace(-2,+2,2000); g.T=5;
g.locus=[-15 15 -30 30]; g.omega=logspace(-2,2,400);

disp('Minimum phase.'); g.ls='k-.'; 
num=2*Conv([1 1],[1 4]); den=Conv(Conv([1 2],[1 2]),[1 2]);
figure(1); Bode(num,den,g); hold on; figure(2); [A,B,C,D]=TF2SS(num,den); Response(A,B,C,D,1,g); hold on; pause;

disp('Maximum phase.'); g.ls='r-'; 
num=2*Conv([1 -1],[1 -4]); den=Conv(Conv([1 2],[1 2]),[1 2]);
figure(1); Bode(num,den,g); figure(2); [A,B,C,D]=TF2SS(num,den); Response(A,B,C,D,1,g); pause;

disp('Mixed phase.'); g.ls='b--';
num=-2*Conv([1 1],[1 -4]); den=Conv(Conv([1 2],[1 2]),[1 2]);
figure(1); Bode(num,den,g); figure(2); [A,B,C,D]=TF2SS(num,den); Response(A,B,C,D,1,g);

figure(1); subplot(2,1,2); axis([.01 100 -470 30]); print -depsc nonminphasebode.eps
figure(2); print -depsc nonminphasestep.eps

end % function SLCTest