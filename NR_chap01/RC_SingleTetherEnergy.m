

clear; syms t phi(t) phidot(t) m g L0 C

Vs(t) = 0.5*m*L0^2*phidot(t)^2 + m*g*L0*(1-cos(phi(t)));
L(t)  = L0*(1+(C)*phi(t)*phidot(t));
disp(' '), Ldot(t) = diff(L(t),t), disp(' ')

disp('Now, manually strip out the (t) [that is, the symbolic function] part of this answer for Ldot, replacing diff(phi(t),t) with phidotdot,')
disp('then combine this with the full definition of V(t) and the dynamic equation for phidotdot(t) in the 3-eqn solve set up and executed below.')
pause

clear; syms t phi phidot Ldot V phidotdot m g L0 C

% Vs = 0.5*m*L0^2*phidot^2 + m*g*L0*(1-cos(phi));
L  = L0*(1+(C)*phi*phidot)
eqn1 = Ldot == L0*(C*phi(t)*diff(phidot(t), t) + C*phidot(t)*diff(phi(t), t))
% eqn1 = Ldot == L0*((C*phi*phidotdot)/((L0^2*m*phidot^2)/2 - L0*g*m*(cos(phi) - 1))^(1/2) + (C*phidot^2)/((L0^2*m*phidot^2)/2 - L0*g*m*(cos(phi) - 1))^(1/2) - (C*phi*phidot*(m*phidot*phidotdot*L0^2 + g*m*sin(phi)*phidot*L0))/(2*((L0^2*m*phidot^2)/2 - L0*g*m*(cos(phi) - 1))^(3/2)))
eqn2 = V    == 0.5*m*(L^2*phidot^2+Ldot^2)+m*g*L*(1-cos(phi))
eqn3 = phidotdot == -(g*sin(phi)+2*Ldot*phidot)/L
SOL=solve(eqn1,eqn2,eqn3,Ldot,V,phidotdot);  disp(' '), disp('V as a function of phi, phidot, and {m,g,L0,C} is given by:')
V=simplify(SOL.V)

g=9.8; m=1; L0=1; C=0.0000001; 
Lphi=.3; Lphidot=.6; Nphi=21; Nphidot=21; eps=1e-9;
Deltaphi=2*Lphi/Nphi; Deltaphidot=2*Lphi/Nphidot;

i=0; for phi=-Lphi:Deltaphi:Lphi-eps, i=i+1; j=0; for phidot=-Lphidot:Deltaphidot:Lphidot-eps, j=j+1; Vnum(i,j)=eval(V); end, end
figure(1); clf; surf(log(Vnum))
