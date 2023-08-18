% script RR_Ex10_34_telegraphers_eqns_wire_junction
% Simulates propogation of a signal across a junction of two wires with
% different properties.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under Modified BSD License.

clear; % Note: this code is hardwired to use termination on the right end.
R=0; G=0; % Try R=0 and G=0.  Also try R=10 and/or G=0.001.
L=525e-9; C=52e-12; Z0=sqrt(L/C), c=1/sqrt(L*C), X=10; N=400; T=X/c;  h=T/1000;
Delta_x=X/(N+0.5); d=1/Delta_x; A=zeros(2*N,2*N);
figure(1); clf, XV=[0:Delta_x:X]; XI=[Delta_x/2:Delta_x:X];
for i=1:N/2,
   if i>1, A(2*i-1,2*i-2)= d/L; end, A(2*i-1,2*i-1)=-R/L; A(2*i-1,2*i)=-d/L; 
           A(2*i,2*i+1)  =-d/C;      A(2*i,  2*i  )=-G/C; A(2*i,2*i-1)= d/C;
end
% IN THE FOLLOWING LINE, WE MODIFY L and/or C IN THE RIGHT HALF OF WIRE
Rr=0; Gr=0; Lr=4*L; Cr=1*C; Z0r=sqrt(Lr/Cr), cr=1/sqrt(Lr*Cr),  
% [Try Lr=alpha*L, Cr=beta*C for {alpha,beta} some combination of {4,1,0.25}.]
for i=N/2+1:N,
           A(2*i-1,2*i-2)= d/Lr;      A(2*i-1,2*i-1)=-Rr/Lr; A(2*i-1,2*i)=-d/Lr; 
   if i<N, A(2*i,2*i+1)  =-d/Cr; end, A(2*i,  2*i  )=-Gr/Cr; A(2*i,2*i-1)= d/Cr;
end
A(2*N,2*N)=A(2*N,2*N)-(d/Cr)/Z0r; % incorporation of termination 
D=eye(2*N)-A*h/2; E=eye(2*N)+A*h/2;
n_max=floor(5*T/h); t1=1e-8; x=zeros(2*N,1); t=0; 
for n=1:n_max
   r=E*x; t=(n-0.5)*h;
   if t<t1, Vleft=(1-cos(pi*t/t1)); else, Vleft=2; end, r(1)=r(1)+(d/L)*h*Vleft;
   x=D\r; t=n*h; Iright=x(2*N)/Z0r;
   if mod(n,50)==0, subplot(2,1,1), plot(XV, [Vleft; x(2:2:2*N)]), axis([0 X -0.2 4.2]), 
                    title(['Voltage, t/T = ',num2str(t/T)]), hold on
                    subplot(2,1,2), plot(XI, [x(1:2:2*N-1); Iright]), axis([0 X -.042 .042]),
                    title(['Current, t/T = ',num2str(t/T)]), hold on, if n<n_max, pause(0.1), clf, end, end
end
