% script RR_Ex10_14_zener_clipper
clear, close all, R=1000; Tmax=7; N=1000; omega=Tmax/N; A=18;
Vd=0.7; Vbr=12; Vmax=Vbr+Vd;
for i=1:N
  omega_t(i)=(i-1)/(N-1)*Tmax;
  Vi(i)=A*sin(omega_t(i));
  if     Vi(i)>Vmax,  Vo(i)=Vmax;
  elseif Vi(i)<-Vmax, Vo(i)=-Vmax;
  else   Vo(i)=Vi(i); end
end
figure(1), subplot(2,1,1); plot(omega_t,Vi,'k--'),  hold on
           plot(omega_t,Vo,'r-')