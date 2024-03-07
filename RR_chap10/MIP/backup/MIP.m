clear, figure(1); clf; % Initialize

% set max time, T, for step responses and sampling period, h, of microcontroller
T=3; h=.01; 
% Inner-loop plant
numG1=[-240 0]; denG1=PolyConv([1 17.9],[1 -14.5],[1 .2]);
% Outer-loop plant
numG2=-.318*PolyConv([1 8.86],[1 -8.86]); denG2=[1 0 0];
% NOTICE! There is a zero at the origin in G1 and two poles at the origin in G2.  
% When multiplying G1 times G2, we will thus have an EXACT pole/zero cancellation, this
% pole/zero pair arises solely because we are representing G in this expanded form.

disp('Identify a first attempt at a stabilizing inner-loop controller D1.');
K=-10, z1=-.2, p1=.2, numD1=K*[1 -z1]; denD1=[1 -p1];
disp('Now checking behavior of inner loop with first attempt at inner-loop controller...')
num=PolyConv(numG1,numD1); den=PolyConv(denD1,denG1);
figure(1), rlocus(num,den), title('Inner-loop root locus (first attempt)')
pause, clf, disp(' ')

disp('Tune inner-loop controller D1 with additional phase lead.');
tr=.03; omegacin=1.8/tr; r=10; K=K*5.2, z1, z2=-omegacin/sqrt(r), p1, p2=-omegacin*sqrt(r)
numD1=K*PolyConv([1 -z1],[1 -z2]); denD1=PolyConv([1 -p1],[1 -p2]);
disp('Now checking behavior of inner loop with tuned inner-loop controller...')
num=PolyConv(numG1,numD1); den=PolyConv(denD1,denG1);
[numC1,denC1]=Feedback(num,den);
[GainMargin,PhaseMargin,Wg,Crossover]=margin(tf(num,den)); PhaseMargin, Crossover
subplot(2,2,1), rlocus(num,den),           title('IL root locus')
subplot(2,2,2), margin(tf(num,den)),       title('IL Bode plot')
subplot(2,2,3), bode(tf(numC1,denC1)),     title('IL closed-loop Bode plot')
subplot(2,2,4), step(tf(numC1,denC1),T),   title('IL step response')
pause, clf, disp(' ')

% Noting inner-loop step response and the plateau in the inner-loop closed-loop Bode plot,
% select a prefactor to give inner loop gain of about 1 across a range of omega.
P=1/1.25;

disp('Outer-loop controller D2 is a single lead compensator.');
tr=.5; omegacout=1.8/tr; r=10; K=1.43, z1=-omegacout/sqrt(r), p1=-omegacout*sqrt(r),
numD2=K*[1 -z1]; denD2=[1 -p1];
disp('Now checking outer-loop behavior with idealized inner loop...')
num=PolyConv(numG2,numD2); den=PolyConv(denD2,denG2);
[numC2i,denC2i]=Feedback(num,den);
[GainMargin,PhaseMargin,Wg,Crossover]=margin(tf(num,den)); PhaseMargin, Crossover
subplot(2,2,1), rlocus(num,den),           title('Ideal OL root locus')
subplot(2,2,2), margin(tf(num,den)),       title('Ideal OL Bode plot')
subplot(2,2,3), bode(tf(numC2i,denC2i)),   title('Ideal OL closed-loop Bode plot')
subplot(2,2,4), step(tf(numC2i,denC2i),T), title('Ideal OL step response')
pause, clf
disp('Now checking outer-loop behavior with the entire system implemented...')
num=P*PolyConv(numD2,numC1,numG2); den=PolyConv(denD2,denC1,denG2);
% NOTICE! There is an EXACT pole/zero cancellation at the origin that occurs here simply 
% because, for convenience, we represented our plant in two pieces, G1 and G2.
% The "minreal" command is used to remove this exactly cancelling pole/zero pair.   
[numC2f,denC2f]=Feedback(num,den); fullsystem=minreal(tf(numC2f,denC2f));
[GainMargin,PhaseMargin,Wg,Crossover]=margin(minreal(tf(num,den))); PhaseMargin, Crossover
subplot(2,2,1), rlocus(num,den),           title('Full OL root locus')
subplot(2,2,2), margin(tf(num,den)),       title('Full OL Bode plot')
subplot(2,2,3), bode(fullsystem),          title('Full OL closed-loop Bode plot')
subplot(2,2,4), step(fullsystem,T),        title('Full OL step response')
pause, clf, disp(' ')

disp(sprintf('D1 and D2 (if implemented in discrete time with h=%0.5g) are:',h))
G1z=c2d(tf(numG1,denG1),h,'zoh');  % The zoh is accounted for once, in the inner loop.
[numD1z,denD1z]=Tustin(numD1,denD1,h,omegacin)   % Convert D1,D2 to discrete time with
[numD2z,denD2z]=Tustin(numD2,denD2,h,omegacout)  % Tustin; also, approximate discrete-time
[numG2z,denG2z]=Tustin(numG2,denG2,h,omegacout); % dynamics of outer loop with Tustin.
D1z=tf(numD1z,denD1z,h); D2z=tf(numD2z,denD2z,h); G2z=tf(numG2z,denG2z,h);
disp('Now checking behavior of discretized inner loop...')
[GainMargin,PhaseMargin,Wg,Crossover]=margin(G1z*D1z); PhaseMargin, Crossover
subplot(2,2,1), rlocus(D1z*G1z),             title('Discrete IL root locus')
subplot(2,2,2), margin(D1z*G1z),             title('Discrete IL Bode plot')
subplot(2,2,3), bode(feedback(D1z*G1z,1)),   title('Discrete IL closed-loop Bode plot')
subplot(2,2,4), step(feedback(D1z*G1z,1),T), title('Discrete IL step response')
pause, clf, disp(' ')
disp('Now checking behavior of discretized outer loop...')
fullOLsys=D2z*P*minreal(feedback(D1z*G1z,1),.001)*G2z; fullsys=feedback(fullOLsys,1);
[GainMargin,PhaseMargin,Wg,Crossover]=margin(fullOLsys); PhaseMargin, Crossover
subplot(2,2,1), rlocus(fullOLsys),         title('Discrete full OL root locus')
subplot(2,2,2), margin(fullOLsys),         title('Discrete full OL open-loop Bode plot')
subplot(2,2,3), bode(fullsys),             title('Discrete full OL closed-loop Bode plot')
subplot(2,2,4), step(fullsys,T),           title('Discrete full OL step response')


