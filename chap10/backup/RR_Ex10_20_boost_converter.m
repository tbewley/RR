% script RR_Ex10_20_boost_converter
% Solves the equations of a boost converter.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under Modified BSD License.

% Solve for the initial conditions of the periodic cycle.  Note that problem is linear!
clear; Vs=5; Vd=0.5; L=10e-6; C=4.7e-6; R=250; f=1.6e6; D=0.600016
sigma=1/(2*R*C); omega_n=1/sqrt(L*C); zeta=sigma/omega_n; omega_d=omega_n*sqrt(1-zeta^2);
v0=Vs-Vd; hA=D/f; hB=(1-D)/f; c1=cos(omega_d*hB); s1=sin(omega_d*hB);
A0=[1/R-C*sigma C*omega_d;-C*omega_d 1/R-C*sigma];
A1=[exp(-hA/(R*C)) 0; 0 1];                      b1=[0; Vs*hA/L];
A2=-([1 0;0 0]+[0 0;1 0]*A0);                    b2=[v0; v0/R];
A3=-exp(-sigma*hB)*([c1 s1;0 0]+[0 0;c1 s1]*A0); b3=b2;
sol=inv([eye(2)-A3*inv(A2)*A1])*(A3*inv(A2)*(b1-b2)+b3); VoutA=sol(1), ILA=sol(2)

% Plot the periodic cycle.
v0=Vs-Vd; i0=v0/R;
sol1=inv(A3)*(sol-b3); vc=sol1(1); vs=sol1(2);
sol2=A0*sol1;          ic=sol2(1); is=sol2(2);
tA=0; tB=D/f; tC=1/f; N=1000; t=0:tC/N:tC;
for i=1:N+1
	if t(i)<tB
		Vout(i)=VoutA*exp(-t(i)/(R*C));
		IL(i)  =ILA + t(i)*Vs/L;
	else
		tau=t(i)-tB;
		Vout(i)=v0-exp(-sigma*tau)*(vc*cos(omega_d*tau)+vs*sin(omega_d*tau));
		IL(i)  =i0-exp(-sigma*tau)*(ic*cos(omega_d*tau)+is*sin(omega_d*tau));
	end
end
figure(1); clf; plot(t,Vout); axis([0 tC min(Vout) max(Vout)]); hold on
   Vmean=sum(Vout(1:N))/N, plot([0 tC],[Vmean Vmean],'k--');
   title('V_{out}(t) during periodic oscillation of boost converter (f=1.6e6)');
   % print -depsc boost_V.eps
figure(2); clf; plot(t,IL);   axis([0 tC min(IL) max(IL)]);  hold on
   Imean=sum(IL(1:N))/N, plot([0 tC],[Imean Imean],'k--');
   title('I_{L}(t) during periodic oscillation of boost converter (f=1.6e6)');
   % print -depsc boost_I.eps
Imean_approx=(Vmean/R)/(1-D)

% Also, plot the "startup" phase (homogeneous ICs, before switching starts).
v0=Vs-Vd; vc=v0; vs=v0*zeta/sqrt(1-zeta^2); i0=v0/R;  
sol=A0*[vc; vs]; ic=sol(1); is=sol(2);
t_max=1e-3; N=1000; t=0:t_max/N:t_max;
for i=1:N+1
	Vout(i)=v0-exp(-sigma*t(i))*(vc*cos(omega_d*t(i))+vs*sin(omega_d*t(i)));
	IL(i)  =i0-exp(-sigma*t(i))*(ic*cos(omega_d*t(i))+is*sin(omega_d*t(i)));
end
figure(3); clf; plot(t,Vout); axis([0 t_max min(Vout) max(Vout)]); hold on
   Vmean=sum(Vout(1:N))/N, plot([0 t_max],[Vmean Vmean],'k--');
   title('V_{out}(t) during startup (before switching starts)');
   % print -depsc boost_V_startup.eps
figure(4); clf; plot(t,IL);   axis([0 t_max min(IL) max(IL)]);  hold on
   Imean=sum(IL(1:N))/N, plot([0 t_max],[Imean Imean],'k--');
   title('I_{L}(t) during startup (before switching starts)'); 
   % print -depsc boost_I_startup.eps