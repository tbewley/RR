% script RR_Boost
% Solves the basic equations of a boost converter.
% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chap10
% Copyright 2024 by Thomas Bewley, published under Modified BSD License.

clear; syms C L R Vs Vd VoutB ILB IL IC IR Vm Vout s
eqn1= Vm-Vout==Vd/s; eqn2= Vout==R*IR; eqn3= IC==C*(s*Vout-VoutB);
eqn4= Vs/s-Vm==L*(s*IL-ILB); eqn5= IL==IC+IR; 
SOL=solve(eqn1,eqn2,eqn3,eqn4,eqn5,IL,IC,IR,Vm,Vout); Vout=SOL.Vout, IL=SOL.IL
pause, disp(' ')

clear; syms B2 B1 B0 b2 b1 b0 sigma omegad
eqn1= b2==B2+B1; eqn2= b1==B2*2*sigma+B1*sigma+B0*omegad; eqn3= b0==B2*(sigma^2+omegad^2);
SOL=solve(eqn1,eqn2,eqn3,B2,B1,B0); B2=SOL.B2, B1=SOL.B1, B0=SOL.B0
pause, disp(' ')

clear; syms R L C Vs Vd omegad sigma D f hA hB VoutA VoutB ILA ILB
omegad=sqrt(1/(L*C)-1/(4*C^2*R^2)); sigma=1/(2*C*R); hA=D/f; hB=(1-D)/f;
B2=Vs-Vd;     B1=VoutB-(Vs-Vd); B0=(ILB/C-VoutB*sigma)/omegad-B2*sigma/omegad;
C2=(Vs-Vd)/R; C1=ILB-(Vs-Vd)/R; C0=((Vs-Vd-VoutB)/L+ILB/(C*R)-ILB*sigma)/omegad-C2;
eqn1= VoutB==VoutA*exp(-hA/(R*C));   eqn2= ILB==Vs*hA/L + ILA;
eqn3= VoutA==B2+B1*exp(-sigma*hB)*cos(omegad*hB)+B0*exp(-sigma*hB)*sin(omegad*hB);
eqn4= ILA  ==C2+C1*exp(-sigma*hB)*cos(omegad*hB)+C0*exp(-sigma*hB)*sin(omegad*hB);
SOL=solve(eqn1,eqn2,eqn3,eqn4,ILB,VoutB,ILA,VoutA);
VoutA=SOL.VoutA, VoutB=SOL.VoutB, ILA=SOL.ILA, ILB=SOL.ILB
pause, disp(' ')

Vs=5; Vd=0.5; L=10e-6; C=4.7e-6; R=250; f=1.6e6; D=7/12; % try also D=0.60086;
VoutA=eval(VoutA), VoutB=eval(VoutB), ILA=eval(ILA), ILB=eval(ILB), disp(' ')
tA=0; tB=D/f; tC=1/f; N=200;
t=0:tC/N:tC;
for i=1:N+1;
  if t(i)<tB
	Vout(i)=VoutA*exp(-t(i)/(R*C));
	IL(i)  =Vs*t(i)/L + ILA;
  else
	Vout(i)=eval(B2+B1*exp(-sigma*(t(i)-tB))*cos(omegad*(t(i)-tB))+B0*exp(-sigma*(t(i)-tB))*sin(omegad*(t(i)-tB)));
	IL(i)  =eval(C2+C1*exp(-sigma*(t(i)-tB))*cos(omegad*(t(i)-tB))+C0*exp(-sigma*(t(i)-tB))*sin(omegad*(t(i)-tB)));
  end
end
figure(1); clf; plot(t,Vout); axis([0 tC min(Vout) max(Vout)]); hold on
   Vmean=sum(Vout(1:N))/N, plot([0 tC],[Vmean Vmean],'k--'); print -depsc boost_V.eps
figure(2); clf; plot(t,IL);   axis([0 tC 0 max(IL)]);  hold on
   Imean=sum(IL(1:N))/N, plot([0 tC],[Imean Imean],'k--'); print -depsc boost_I.eps

Imean_approx=(Vmean/R)/(1-D)

