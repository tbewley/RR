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
T=y0_(end); t(1)=     d+(-log((T1-Tmax)/(T-Tmax)))/a0; t1_=[     d: t(1)      /100:t(1)+d]; y1_=Tmax+(T-Tmax)*exp(-a0*(t1_-      d ));
T=y1_(end); t(2)=t(1)+d+(-log((T1-Tmin)/(T-Tmin)))/a0; t2_=[t(1)+d:(t(2)-t(1))/100:t(2)+d]; y2_=Tmin+(T-Tmin)*exp(-a0*(t2_-(t(1)+d)));
T=y2_(end); t(3)=t(2)+d+(-log((T1-Tmax)/(T-Tmax)))/a0; t3_=[t(2)+d:(t(3)-t(2))/100:t(3)+d]; y3_=Tmax+(T-Tmax)*exp(-a0*(t3_-(t(2)+d)));
T=y3_(end); t(4)=t(3)+d+(-log((T1-Tmin)/(T-Tmin)))/a0; t4_=[t(3)+d:(t(4)-t(3))/100:t(4)+d]; y4_=Tmin+(T-Tmin)*exp(-a0*(t4_-(t(3)+d)));
T=y4_(end); t(5)=t(4)+d+(-log((T1-Tmax)/(T-Tmax)))/a0; t5_=[t(4)+d:(t(5)-t(4))/100:t(5)+d]; y5_=Tmax+(T-Tmax)*exp(-a0*(t5_-(t(4)+d)));
T=y5_(end); t(6)=t(5)+d+(-log((T1-Tmin)/(T-Tmin)))/a0; t6_=[t(5)+d:(t(6)-t(5))/100:t(6)+d]; y6_=Tmin+(T-Tmin)*exp(-a0*(t6_-(t(5)+d)));
t_=[t0_ t1_ t2_ t3_ t4_ t5_ t6_]; y_=[y0_ y1_ y2_ y3_ y4_ y5_ y6_];
figure(1), plot(t_,y_,'k-','linewidth',2), hold on, axis tight
T=t_(end); yticks([35:1:46]); xticks([0:10:T]), grid
for i=1:2:5,
	plot([t(i  )   t(i  )  ],[35 46.07],'r-');
	plot([t(i  )+d t(i  )+d],[35 46.07],'r--');
    plot([t(i+1)   t(i+1)  ],[35 46.07],'b-');
    plot([t(i+1)+d t(i+1)+d],[35 46.07],'b--');
end, hold off

pause; disp('Now doing feedforward control.')
figure(2);  T=T0; t(1)=d+(-log((T1-Tmax)/(T-Tmax)))/a0; 
t1_=[d:(t(1)-d)/100:t(1)]; y1_=Tmax+(T-Tmax)*exp(-a0*(t1_-d));
t2_f=[t(1) 200]; y2_f=[T1 T1];
t_=[t0_ t1_ t2_f]; y_=[y0_ y1_ y2_f]; plot(t_,y_,'k-','linewidth',2), hold on, axis tight
yticks([35:1:46]); xticks([0:10:T]), grid
plot([t(1)   t(1)  ],[35 45.07],'r-');
plot([62.1651 62.1651],[35 45.07],'r-'); disp('settling time: 62.1651 sec')
