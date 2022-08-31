% script RR_Telegraphers_Equations
% Simulates the Telegraphers Equations.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under Modified BSD License.

clear; termination=true % try both termination=true and termination=false
R=10; G=0.001;          % also try R=10 and/or G=0.001 
L=525e-9; C=52e-12; Z0=sqrt(L/C), c=1/sqrt(L*C), X=10; N=2000, T=X/c;  h=T/10000
Delta_x=X/(N+0.5); d=1/Delta_x; A=zeros(2*N,2*N);
figure(1); clf, XV=[0:Delta_x:X]; XI=[Delta_x/2:Delta_x:X];
for i=1:N,
   if i>1, A(2*i-1,2*i-2)= d/L; end, A(2*i-1,2*i-1)=-R/L; A(2*i-1,2*i)=-d/L; 
   if i<N, A(2*i,2*i+1)  =-d/C; end, A(2*i,  2*i  )=-G/C; A(2*i,2*i-1)= d/C;       
end
if termination, A(2*N,2*N)=A(2*N,2*N)-(d/C)/Z0; end
D=eye(2*N)-A*h/2; E=eye(2*N)+A*h/2;
n_max=floor(5.050001*T/h); t1=1e-9; x=zeros(2*N,1); t=0; 
for n=1:n_max
   r=E*x; t=(n-0.5)*h;
   if t<t1, Vleft=(1-cos(pi*t/t1)); else, Vleft=2; end, r(1)=r(1)+(d/L)*h*Vleft;
   x=D\r; t=n*h;
   if termination, Iright=x(2*N)/Z0; else, Iright=0; end
   if mod(n,50)==0, subplot(2,1,1), plot(XV, [Vleft; x(2:2:2*N)]), axis([0 X -0.2 4.2]), 
                    title(['Voltage, t/T = ',num2str(t/T)]), hold on
                    subplot(2,1,2), plot(XI, [x(1:2:2*N-1); Iright]), axis([0 X -.022 .022]),
                    title(['Current, t/T = ',num2str(t/T)]), hold on, pause(0.2), end
   if termination
      if n==1200
         subplot(2,1,1), title(['Voltage, t/T = ',num2str(0.05),', ',num2str(0.1),', ... , ',num2str(t/T)])
         subplot(2,1,2), title(['Current, t/T = ',num2str(0.05),', ',num2str(0.1),', ... , ',num2str(t/T)])
         % print -depsc telegraphers_terminated
         break
     end
   else
      if (n==1050) | (n==2050) | (n==3050) | (n==4050)
         subplot(2,1,1), title(['Voltage, t/T = ',num2str(t/T-0.95),', ',num2str(t/T-0.9),', ... , ',num2str(t/T)])
         subplot(2,1,2), title(['Current, t/T = ',num2str(t/T-0.95),', ',num2str(t/T-0.9),', ... , ',num2str(t/T)])
         % print -depsc telegraphers_notermination
         pause, clf
      end
   end
end