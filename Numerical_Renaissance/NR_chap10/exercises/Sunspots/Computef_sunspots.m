function f=Computef(y)
alpha_k=1.8;         % kinetic helicity
nrd=-3.3;            % D=nrd*helicity - dynamo number
nu=0.03;             % Characterize time
lam=0.0000032;       % =Re^(-2), where Re - Reinolds number
xi=5.9;              % Quenching parameter

alpha_k=3.2;           % kinetic helicity
nrd=-0.82;             % D=nrd*helicity - dynamo number
nu=1.28;               % Characterize time
lam=0.00000123;        % =Re^(-2), where Re - Reinolds number
xi=.0039;              % Quenching parameter

bk0=alpha_k/(1 + xi*(y(3)^2 + y(4)^2));
bk1=y(1)^2 - y(2)^2;
bk2=-y(3)^2 + y(4)^2;

f=[-y(1) + nrd*(bk0*y(3) + y(3)*y(5) - y(4)*y(6));
   -y(2) + nrd*(bk0*y(4) + y(4)*y(5) + y(3)*y(6));
   -y(2) - y(3);
   y(1) - y(4);
   bk0*nrd*(lam*bk1+bk2) - nu*y(5) + nrd*(y(5)*(lam*bk1+bk2) - 2*lam*y(1)*y(2)*y(6) + 2*y(3)*y(4)*y(6));
   2*bk0*nrd*(lam*y(1)*y(2) - y(3)*y(4)) - nu*y(6) + nrd*(2*lam*y(1)*y(2)*y(5) - 2*y(3)*y(4)*y(5) + lam*y(6)*bk1+y(6)*bk2)];
end
