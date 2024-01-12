% script RR_Ex10_13_full_wave_rectifier
%% Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License.

clear, close all, R=1000; Tmax=7; N=1000; omega=Tmax/N; A=18; Vd=0.7;
for i=1:N
  omega_t(i)=(i-1)/(N-1)*Tmax;
  Vi(i)=A*sin(omega_t(i));
  if abs(Vi(i))<2*Vd; Vo(i)=0;
  else Vo(i)=abs(Vi(i))-2*Vd; end
  I_load(i)=Vo(i)/R;
  P_load(i)=Vo(i)*I_load(i);
  P_diodes(i)=2*I_load(i);
  epsilon(i)=P_diodes(i)/(P_load(i)+P_diodes(i));
end
figure(1), subplot(2,1,1); plot(omega_t,Vi,'k--'),  hold on
           plot(omega_t,Vo,'r-')
figure(2), plot(omega_t,I_load,'r-.'), title('r-. I_{load}'),
figure(3), plot(omega_t,P_load,'b-'), hold on 
           plot(omega_t,P_diodes,'r-.'), title('b- P_{load}, r-. P_{diodes}')
figure(4); subplot(2,1,1); plot(omega_t,100*epsilon)

average_value_of_Vo=sum(Vo)/N
average_value_of_epsilon=sum(epsilon,'omitnan')/N

