clear
R_over_H=1;
H=30; R=R_over_H*H;
rho_atm=1.225;
rho_atm_minus_rho_lift_gas=1.052;
rho_fabric=0.1;
rho_tether=0.37e-3;
p=2;
g=9.8;
W_payload=10*g;
H=30;
w=13;
Cd=0.2
nu=14.8e-6;

syms r
D=Cd*rho_atm * pi*r^2 * w^2/2;
L=rho_atm_minus_rho_lift_gas * g * 4*pi*r^3/3;
W_fabric=rho_fabric*4*pi*r^2;
W_tether=p*rho_tether*sqrt(R^2+H^2);

r=max(roots(sym2poly(R_over_H*(L-W_fabric-W_tether-W_payload)-D)))

D=eval(D)
L=eval(L)
W_fabric=eval(W_fabric)
W_tether
W_payload
Re=2*r*w/nu
Fr=w/sqrt(g*r)

disp('Note: check http://www.aerospaceweb.org/question/aerodynamics/q0231.shtml')
disp('and adjust Cd to match Re (you might need to iterate a couple of times).')