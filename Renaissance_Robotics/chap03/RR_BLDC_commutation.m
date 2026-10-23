% script RR_BLDC_commutation
% Illustrates trapezoidal, sinusoidal, and third-order harmonic commutation of BLDC motors.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 3)
%% Copyright 2026 by Thomas Bewley, published under BSD 3-Clause License.

T=[-29.5:1:389.5];
for i=1:length(T)
  if     T(i)<  0+30 | T(i)>300+30, u(i)=1; v(i)=1; w(i)=1; uh(i)=0; vh(i)=1; wh(i)=0;
  elseif T(i)< 60+30,               u(i)=1; v(i)=1; w(i)=0; uh(i)=0; vh(i)=1; wh(i)=1;
  elseif T(i)<120+30,               u(i)=1; v(i)=0; w(i)=0; uh(i)=0; vh(i)=0; wh(i)=1;
  elseif T(i)<180+30,               u(i)=0; v(i)=0; w(i)=0; uh(i)=1; vh(i)=0; wh(i)=1;
  elseif T(i)<240+30,               u(i)=0; v(i)=0; w(i)=1; uh(i)=1; vh(i)=0; wh(i)=0;
  elseif T(i)<300+30,               u(i)=0; v(i)=1; w(i)=1; uh(i)=1; vh(i)=1; wh(i)=0; end
end
figure(1); clf; t=tiledlayout(15,1,'TileSpacing','tight','Padding','tight');
nexttile, plot(T,u,'b-'), axis off, axis tight
nexttile, plot(T,v,'b-'), axis off, axis tight
nexttile, plot(T,w,'b-'), axis off, axis tight
nexttile, plot(T,uh,'r-'), axis off, axis tight
nexttile, plot(T,vh,'r-'), axis off, axis tight
nexttile, plot(T,wh,'r-'), axis off, axis tight
tix=[0 30 60 90 120 150 180 210 240 270 300 330 360];
Ttrap=[-30 30  90 150 210 270 330 390];
Atrap=[-1   1   1   1  -1  -1  -1   1];
Btrap=[-1  -1  -1   1   1   1  -1  -1];
Ctrap=[ 1   1  -1  -1  -1   1   1   1];
Athird=sind(T)+sind(3*T)/5;  M=max(Athird); Athird=Athird/M; Athird_fundamental=sind(T)/M; m=1/M;
Bthird=sind(T-120)+sind(3*T)/5;         Bthird=Bthird/M; Bthird_fundamental=sind(T-120)/M;
Cthird=sind(T-240)+sind(3*T)/5;         Cthird=Cthird/M; Cthird_fundamental=sind(T-240)/M;
nexttile([3 1]); plot(T,sind(T-120),'b-'),  axis([-30 390 -1/M 1/M]), xticks(tix), grid on, hold on;
                 plot(Ttrap,Btrap,'r--'), plot(T,Bthird,'k-'), plot(T,Bthird_fundamental,'k:'), plot(T,sind(3*T)/5/M,'k:')
                 plot([30 30],[-m m],'k-');  plot([90 90],[-m m],'k-');  plot([150 150],[-m m],'k-'); 
                 plot([210 210],[-m m],'k-');  plot([270 270],[-m m],'k-');  plot([330 330],[-m m],'k-'); 
nexttile([3 1]); plot(T,sind(T),'b-'),  axis([-30 390 -1/M 1/M]), xticks(tix), grid on, hold on;
                 plot(Ttrap,Atrap,'r--'), plot(T,Athird,'k-'), plot(T,Athird_fundamental,'k:'), plot(T,sind(3*T)/5/M,'k:')
                 plot([30 30],[-m m],'k-');  plot([90 90],[-m m],'k-');  plot([150 150],[-m m],'k-'); 
                 plot([210 210],[-m m],'k-');  plot([270 270],[-m m],'k-');  plot([330 330],[-m m],'k-'); 
nexttile([3 1]); plot(T,sind(T-240),'b-'),  axis([-30 390 -1/M 1/M]), xticks(tix), grid on, hold on;
                 plot(Ttrap,Ctrap,'r--'), plot(T,Cthird,'k-'), plot(T,Cthird_fundamental,'k:'), plot(T,sind(3*T)/5/M,'k:')
                 plot([30 30],[-m m],'k-');  plot([90 90],[-m m],'k-');  plot([150 150],[-m m],'k-'); 
                 plot([210 210],[-m m],'k-');  plot([270 270],[-m m],'k-');  plot([330 330],[-m m],'k-'); 
