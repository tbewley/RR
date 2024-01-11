function Waterbed(Lnum,Lden,g)
% Plot ln|S(i*omega)| where S=1/[1+L(s)] and L(s)=Lnum(s)/Lden(s)
% thereby demonstrating Bode's integral theorem.
% The derived type g groups together convenient plotting parameters: g.omega is the set of
% frequencies used.
% and, if nargin=4, h is the timestep (where the Nyquist frequency is N=pi/h).
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 17.5.2.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help BodeTest">BodeTest</a>.  Depends on <a href="matlab:help PolyVal">PolyVal</a>.

Snum=Lden; Sden=PolyAdd(Lnum,Lden); eps=0; max=35; omega=[eps:(max-eps)/200:max];
semilogy(omega,abs(PolyVal(Snum,i*omega)./PolyVal(Sden,i*omega)),'b-'), hold on
a=axis; c=-g.kappa*pi/2, plot([a(1) a(2)],[exp(c) exp(c)],'k-')
end % function Waterbed