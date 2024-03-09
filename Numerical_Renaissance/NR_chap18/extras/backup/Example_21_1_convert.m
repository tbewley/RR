function [u_k]=Example_21_1_convert(T,x_k)
s.g=9.8;   s.h=0.01; s.N=T/s.h;  s.mc=1; t=[0:s.N]*s.h;    % step 0: initialize simulation,
s.m1=0.5;  s.L1=1;   s.ell1=s.L1/2; s.I1=s.m1*s.ell1^2/12; % system, and derived parameters
s.m2=0.25; s.L2=0.5; s.ell2=s.L2/2; s.I2=s.m2*s.ell2^2/12; s.B=[0; 0; 0; 1; 0; 0];

for n=1:s.N+1
  E=Compute_E(x_k(1:6,n),s); N=Compute_N(x_k(1:6,n),0,s); u_k(n,1)=s.B'*(E*x_k(4:9,n)-N);
end

end % function Example_21_1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function R=RHS(x,u,s);
E=Compute_E(x,s); N=Compute_N(x,u,s); R=E\N;
end % function RHS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function E=Compute_E(x,s);
E=[eye(3) zeros(3); zeros(3) ...
[s.mc+s.m1+s.m2         -s.m1*s.ell1*cos(x(2)) -s.m2*s.ell2*cos(x(3));
 -s.m1*s.ell1*cos(x(2))  s.I1+s.m1*s.ell1^2             0            ;
 -s.m2*s.ell2*cos(x(3))          0              s.I2+s.m2*s.ell2^2   ]];
end % function Compute_E
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function N=Compute_N(x,u,s);
N=[x(4); x(5); x(6); -s.m1*s.ell1*sin(x(2))*x(5)^2-s.m2*s.ell2*sin(x(3))*x(6)^2+u;
 s.m1*s.g*s.ell1*sin(x(2)); s.m2*s.g*s.ell2*sin(x(3)) ];
end % function Compute_N
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function A=Compute_A(x,s);
a42=s.m1*s.ell1*(x(8)*sin(x(2))+x(5)^2*cos(x(2))); a45=2*s.m1*s.ell1*x(5)*sin(x(2));
a43=s.m2*s.ell2*(x(9)*sin(x(3))+x(6)^2*cos(x(3))); a46=2*s.m2*s.ell2*x(6)*sin(x(3));
a52=s.m1*s.ell1*(s.g*cos(x(2))-x(7)*sin(x(2)));
a63=s.m2*s.ell2*(s.g*cos(x(3))-x(7)*sin(x(3)));
A=[zeros(3) eye(3); 0 -a42 -a43 0 -a45 -a46; 0 a52 0 0 0 0; 0 0 a63 0 0 0];
end % function Compute_A
