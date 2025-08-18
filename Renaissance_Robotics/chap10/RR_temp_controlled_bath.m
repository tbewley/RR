% script RR_temp_controlled_bath
% This code performs some calculations related to a temperature-controlled bath,
% with a convective delay of d seconds between the valve and the faucet where the
% water enters the bath.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 10)
%% Copyright 2025 by Thomas Bewley, published under BSD 3-Clause License.

clear; close all
T0=35; T1=45; Tmax=50; Tmin=10; a0=.02, d=12

disp('first calculate the analysical solution for a simple control rule with')
disp('u(t)=Tmax if y(t)<T(t), u(t)=T(t) if y(t)=T(t), u(t)=Tmin if y(t)>T(t)')
t0_=[0 d]; y0_=[T0 T0];
T=y0_(end); t1=d +(-log((T1-Tmax)/(T-Tmax)))/a0;    t1_=[d:t1/100:t1+d];         y1_=Tmax+(T-Tmax)*exp(-a0*(t1_-d));
T=y1_(end); t2=t1+d+(-log((T1-Tmin)/(T-Tmin)))/a0;  t2_=[t1+d:(t2-t1)/100:t2+d]; y2_=Tmin+(T-Tmin)*exp(-a0*(t2_-(t1+d)));
T=y2_(end); t3=t2+d+(-log((T1-Tmax)/(T-Tmax)))/a0;  t3_=[t2+d:(t3-t2)/100:t3+d]; y3_=Tmax+(T-Tmax)*exp(-a0*(t3_-(t2+d)));
T=y3_(end); t4=t3+d+(-log((T1-Tmin)/(T-Tmin)))/a0;  t4_=[t3+d:(t4-t3)/100:t4+d]; y4_=Tmin+(T-Tmin)*exp(-a0*(t4_-(t3+d)));
T=y4_(end); t5=t4+d+(-log((T1-Tmax)/(T-Tmax)))/a0;  t5_=[t4+d:(t5-t4)/100:t5+d]; y5_=Tmax+(T-Tmax)*exp(-a0*(t5_-(t4+d)));
T=y5_(end); t6=t5+d+(-log((T1-Tmin)/(T-Tmin)))/a0;  t6_=[t5+d:(t6-t5)/100:t6+d]; y6_=Tmin+(T-Tmin)*exp(-a0*(t6_-(t5+d)));
t=[t0_ t1_ t2_ t3_ t4_ t5_ t6_]; y=[y0_ y1_ y2_ y3_ y4_ y5_ y6_];
figure(1), plot(t,y), axis tight, pause
