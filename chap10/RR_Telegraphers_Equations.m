% script RR_Telegraphers_Equations
% Simulates the Telegraphers Equations.
% Renaissance Robotics codebase, Chapter 10, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under Modified BSD License.

clear; termination=true  
R=0; G=0; % also try G=1e-3 or R=1e1;
L=525e-9; C=52e-12; Z0=sqrt(L/C), c=1/sqrt(L*C), 
h=4e-11;  X=10; N=200; Delta_x=X/(N+0.5), d=1/Delta_x;  
A=zeros(2*N,2*N);
for i=1:N,
   if i>1, A(2*i-1,2*i-2)= d/L; end, A(2*i-1,2*i-1)=-R/L; A(2*i-1,2*i)=-d/L; 
   if i<N, A(2*i,2*i+1)  =-d/C; end, A(2*i,  2*i  )=-G/C; A(2*i,2*i-1)= d/C;       
end
if termination, A(2*N,2*N)=A(2*N,2*N)-(d/C)/Z0; end
D=eye(2*N)-A*h/2;
E=eye(2*N)+A*h/2;

T=X/c; n_max=floor(5*T/h); t1=1e-8;
x=zeros(2*N,1); t=0;
for n=1:n_max
   r=E*x; t=(n-0.5)*h;
   if t<t1, r(1)=r(1)+(d/L)*h*(1-cos(pi*t/t1)); else, r(1)=r(1)+(d/L)*h*2; end
   x=D\r; t=n*h;
   if mod(n,80)==0, figure(1); plot(x(2:2:2*N)), axis([0 N -0.1 4.1]), text(N/2,1,['t=',num2str(t)]), pause; end
end
