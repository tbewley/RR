% script RR_Ex10_33_telegraphers_eqns_termination
% Simulates the Telegraphers equations, for different possibilities of termination.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under Modified BSD License.

clear; termination=true      % try both termination=true and termination=false
R=10; G=0.002;               % Try R=0 and G=0.  Also try R=10 and/or G=0.001.
% t1=1e-8, N=200,  Nt=1000;  % Try either these three values...
t1=1e-9, N=2000, Nt=10000;   % ... or (if you are patient) these three values.
L=525e-9; C=52e-12;
Z0=sqrt(L/C), c=1/sqrt(L*C), X=10; T=X/c; h=T/Nt
Delta_x=X/(N+0.5); d=1/Delta_x; A=zeros(2*N,2*N);
figure(1); clf, XV=[0:Delta_x:X]; XI=[Delta_x/2:Delta_x:X];
for i=1:N,
   if i>1, A(2*i-1,2*i-2)= d/L; end, A(2*i-1,2*i-1)=-R/L; A(2*i-1,2*i)=-d/L; 
   if i<N, A(2*i,2*i+1)  =-d/C; end, A(2*i,  2*i  )=-G/C; A(2*i,2*i-1)= d/C;       
end
if termination, A(2*N,2*N)=A(2*N,2*N)-(d/C)/Z0; end
D=sparse(eye(2*N)-A*h/2); E=sparse(eye(2*N)+A*h/2);
n_max=floor(5.050001*T/h); x=zeros(2*N,1); t=0; 
for n=1:n_max
   r=E*x; t=(n-0.5)*h;
   if t<t1, Vleft=(1-cos(pi*t/t1)); else, Vleft=2; end, r(1)=r(1)+(d/L)*h*Vleft;
   x=D\r; t=n*h;
   if termination, Iright=x(2*N)/Z0; else, Iright=0; end
   if mod(n,Nt/20)==0, subplot(2,1,1), plot(XV, [Vleft; x(2:2:2*N)]), axis([0 X -0.2 4.2]), 
                    title(['Voltage, t/T = ',num2str(t/T)]), hold on
                    subplot(2,1,2), plot(XI, [x(1:2:2*N-1); Iright]), axis([0 X -.022 .022]),
                    title(['Current, t/T = ',num2str(t/T)]), hold on, pause(0.2), end
   if termination
      if n==Nt*1.2
         subplot(2,1,1), title(['Voltage, t/T = ',num2str(0.05),', ',num2str(0.1),', ... , ',num2str(t/T)])
         subplot(2,1,2), title(['Current, t/T = ',num2str(0.05),', ',num2str(0.1),', ... , ',num2str(t/T)])
         % print -depsc telegraphers_terminated
         break
     end
   else
      if (n==Nt*1.05) | (n==Nt*1.05) | (n==Nt*1.05) | (n==Nt*1.05)
         subplot(2,1,1), title(['Voltage, t/T = ',num2str(t/T-0.95),', ',num2str(t/T-0.9),', ... , ',num2str(t/T)])
         subplot(2,1,2), title(['Current, t/T = ',num2str(t/T-0.95),', ',num2str(t/T-0.9),', ... , ',num2str(t/T)])
         % print -depsc telegraphers_notermination
         pause, clf
      end
   end
end