function LagLeadNotchTest                            % Numerical Renaissance Codebase 1.0

disp('%%%%%%%%% System #1 %%%%%%%%%'); zbar=0.99; pbar=0; numG=[1 zbar]; denG=[1 pbar];

disp('Proportional feedback'); K=1; TestSystem(numG,denG,K,30)

disp('Lag compensation (z>p)');  K=1; z=3; p=1; numD=[1 z]; denD=[1 p];           
disp('Note: faster step response!');  TestSystem(Conv(numG,numD),Conv(denG,denD),K,30)      

disp('%%%%%%%%% System #2 %%%%%%%%%'); pbar=.501; numG=[1]; denG=Conv([1 pbar],[1 -pbar]);

disp('Proportional feedback'); K=1; TestSystem(numG,denG,K,30)

disp('Lead compensation (z<p)'); K=5; z=.5; p=3; numD=[1 z]; denD=[1 p];
disp('Note: oscillation stabilized!');  TestSystem(Conv(numG,numD),Conv(denG,denD),K,30) 

disp('%%%%%%%%% System #3 %%%%%%%%%'); pbar=.5; numG=[1]; denG=[1 0 pbar^2];

disp('Proportional feedback'); K=1; TestSystem(numG,denG,K,30)

disp('Lead compensation (z<p)'); K=3; z=.5; p=3; numD=[1 z]; denD=[1 p];
disp('Bad overshoot, but the solution is not sensitive to precise value of pbar');
TestSystem(Conv(numG,numD),Conv(denG,denD),K,30)

disp('Notch (z<pbar)'), K=2; z=0.49; p=1.5; numD=[1 0 z^2]; denD=Conv([1 p],[1 p]);
disp('Overshoot taken care of! :)'), TestSystem(Conv(numG,numD),Conv(denG,denD),K,30)
disp('Decaying wiggle in response'), TestSystem(Conv(numG,numD),Conv(denG,denD),K,1000)

disp('Notch (z>pbar)'), K=2; z=0.51; p=1.5; numD=[1 0 z^2]; denD=Conv([1 p],[1 p]);
disp('Overshoot still ok...'), TestSystem(Conv(numG,numD),Conv(denG,denD),K,30)      
disp('... but unstable! :('),  TestSystem(Conv(numG,numD),Conv(denG,denD),K,1000)

end % function LagLeadNotchTest

function TestSystem(num,den,K,T)
figure(1); RLocus(num,den,logspace(log10(K)-2,log10(K)+2,100)',K,[-3.01 1 -2 2]);
figure(2); clf; Bode(K*num,den,logspace(-2,2,10000),'k',0)
numH=K*num; denH=den+[zeros(1,size(den,2)-size(num,2)) K*num];
outer_gain=denH(end)/numH(end);
if T<1000,
  outer_gain, numH, denH, CL_zeros=Roots(numH)', CL_poles=Roots(denH)'
else
  figure(1); axis([-.01 .01 .487 .513])
end, disp(' '),
figure(3); clf; [A,B,C,D]=TF2SS(outer_gain*numH,denH); Response(T,1,A,B,C,D); % Step
  axis([0 T 0 2]); hold on; plot([0 T],[1 1],'k--'); hold off;                % response
figure(4); clf; Bode(outer_gain*numH,denH,logspace(-2,2,10000),'k',0); pause;
end % function TestSystem
