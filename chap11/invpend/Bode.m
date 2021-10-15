function Bode(num,den,g)                             % Numerical Renaissance Codebase 1.0
subplot(2,1,1), loglog(g.omega,abs(polyval(num,i*g.omega)./polyval(den,i*g.omega)), ...
g.linestyle); a=axis; hold on; plot([a(1) a(2)],[1 1],'k:')
% ph=mod(phase(polyval(num,i*g.omega)./polyval(den,i*g.omega))*180/pi+180,360)-180;
ph=phase(polyval(num,i*g.omega)./polyval(den,i*g.omega))*180/pi + g.extra;
subplot(2,1,2), semilogx(g.omega,ph,g.linestyle); a=axis; hold on;
plot([a(1) a(2)],[-180 -180],'k:')
end % function Bode.m