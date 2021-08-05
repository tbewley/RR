function Bode(num,den,g,h)
% function Bode(num,den,g,h)
% The continuous-time Bode plot of G(s)=num(s)/den(s) if nargin=3, with s=(i omega), or
% the discrete-time   Bode plot of G(z)=num(z)/den(z) if nargin=4, with z=e^(i omega h).
% The derived type g groups together convenient plotting parameters: g.omega is the set of
% frequencies used, g.style is the linestyle, g.line turns on/off a line at -180 degrees,
% and, if nargin=4, h is the timestep (where the Nyquist frequency is N=pi/h).
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 17.5.2.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help BodeTest">BodeTest</a>.  Depends on <a href="matlab:help PolyVal">PolyVal</a>.

if nargin==4, N=pi/h; g.omega=logspace(log10(g.omega(1)),log10(0.999*N),length(g.omega));
  arg=exp(i*g.omega*h); else arg=i*g.omega; end
subplot(2,1,1), loglog(g.omega,abs(PolyVal(num,arg)./PolyVal(den,arg)),g.style), hold on
a=axis; plot([a(1) a(2)],[1 1],'k:'), if nargin==4, plot([N N],[a(3) a(4)],'k--'), end
subplot(2,1,2), semilogx(g.omega,Phase(PolyVal(num,arg)./PolyVal(den,arg))*180/pi,g.style)
hold on, a=axis; if g.line==1, plot([a(1) a(2)],[-180 -180],'k:'), a=axis; end
if nargin==4, plot([N N],[a(3) a(4)],'k--'), end
end % function Bode