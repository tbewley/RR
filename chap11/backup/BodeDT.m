function BodeDT(num,den,g)
% function BodeDT(num,den,g)
% Plot the Bode plot of G(z)=num(z)/den(z).
% The derived type g groups together convenient plotting parameters: g.omega is the set of
% frequencies used, g.style is the linestyle, g.line turns on/off a line at -180 degrees,
% g.h is the timestep.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 18.1.5.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap18">Chapter 18</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help BodeDTtest">BodeDTtest</a>.  Depends on <a href="matlab:help PolyVal">PolyVal</a>.

subplot(2,1,1), loglog(g.omega,abs(PolyVal(num,i*g.omega)./PolyVal(den,i*g.omega)),g.style)
a=axis; hold on; plot([a(1) a(2)],[1 1],'k:')
subplot(2,1,2), ph=Phase(PolyVal(num,i*g.omega)./PolyVal(den,i*g.omega))*180/pi;
semilogx(g.omega,ph,g.style); hold on; if g.line, plot([a(1) a(2)],[-180 -180],'k:'), end
end % function BodeDT
