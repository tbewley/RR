% script RR_Ex10_13_full_wave_rectifier
clear, close all, R=10000; Tmax=7;
N=1000; for i=1:N
  omega_t(i)=i*Tmax/N;
  V_i(i)=10*sin(omega_t(i));
  if abs(V_i(i))<2; V_load(i)=0;
  else V_load(i)=abs(V_i(i))-2; end
  I_load(i)=V_load(i)/R;
  P_load(i)=V_load(i)*I_load(i);
  P_diodes(i)=2*I_load(i);
  epsilon(i)=P_diodes(i)/(P_load(i)+P_diodes(i));
end
figure(1), plot(omega_t,V_i,'k-'),  hold on
           plot(omega_t,V_load,'b-.'), title('k- V_i, b-- V_{load}')
figure(2), plot(omega_t,I_load,'r-.'), title('r-. I_{load}'),
figure(3), plot(omega_t,P_load,'b-'), hold on 
           plot(omega_t,P_diodes,'r-.'), title('b- P_{load}, r-. P_{diodes}')
figure(4); plot(omega_t,epsilon), title('b- epsilon')
