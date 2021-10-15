% script <a href="matlab:BodeTest">BodeTest</a>
% Test <a href="matlab:help Bode">Bode</a> by plotting the Bode plot of 1st-order and 2nd-order systems.
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 17.5.2.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap17">Chapter 17</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.

figure(1); clf; g.omega=logspace(-1,1,500); g.line=0; bs=[1 0 1]; as=[1 2 1];
g.style='k-'; Bode(bs,as,g), hold on, h=1;
g.style='b-'; [bz,az]=C2DTustin(bs,as,h);   Bode(bz,az,g,h)
g.style='r-'; [bz,az]=C2DTustin(bs,as,h,1); Bode(bz,az,g,h)

figure(2); clf; g.omega=logspace(-1,1,201); g.line=0; bs=[1 .3]; as=[1 12 20 0 0];
g.style='k-'; Bode(bs,as,g), hold on, h=1; g.line=1; subplot(2,1,1), axis(10.^[-1 1 -5 1])
g.style='b-'; [bz,az]=C2DTustin(bs,as,h);   Bode(bz,az,g,h)
g.style='r-'; [bz,az]=C2DTustin(bs,as,h,2.5); Bode(bz,az,g,h)

break

figure(3); clf; g.omega=logspace(-1,1,500);
g.style='k-';  zeta=.01;  Bode([1],[1 2*zeta 1],g);
g.style='k-.'; zeta=.1;   Bode([1],[1 2*zeta 1],g);
g.style='k-.'; zeta=.2;   Bode([1],[1 2*zeta 1],g);
g.style='k-.'; zeta=.3;   Bode([1],[1 2*zeta 1],g);
g.style='k-.'; zeta=.5;   Bode([1],[1 2*zeta 1],g);
g.style='r-';  zeta=.707; Bode([1],[1 2*zeta 1],g);
g.style='b--'; zeta=1;    Bode([1],[1 2*zeta 1],g);

figure(4); clf; g.omega=logspace(-2,2,500); g.line=0; s='k--';
g.style='b-';  Bode([1 1 100],100*PolyConv([1 .1],[1 .2 1]),g)
g.style='r-.'; Bode([1 1 100],100*PolyConv([1 .1],[1  2 1]),g)
subplot(2,1,1), plot([.01 .1],[10 10],s,[.1 1],[10 1],s,[1 10],[1 .001],s,[10,100],[.001 .0001],s); axis(10.^[-2 2 -4.2 1.2])
subplot(2,1,2), plot([.01 .02],[0 0],s,[.02 .5],[0 -90],s,[.5 1],[-90 -90],s,[1 10],[-270 -270],s,[10,100],[-90 -90],s);

figure(5); clf; g.omega=logspace(-3,3,500); g.line=0; s='k--';
g.style='b-';   Bode([1 10 10000],100*PolyConv([1 .01],[1 .2 1]),g)
g.style='r-.';  Bode([1 10 10000],100*PolyConv([1 .01],[1  2 1]),g)
subplot(2,1,1), plot([.001 .01],[10000 10000],s,[.01 1],[10000 100],s,[1 100],[100 .0001],s,[100,1000],[.0001 .00001],s); axis(10.^[ -3 3 -5.2 4.2])
subplot(2,1,2), plot([.001 .002],[0 0],s,[.002 .05],[0 -90],s,[.05 1],[-90 -90],s,[1 100],[-270 -270],s,[100,1000],[-90 -90],s);

figure(6); clf; g.omega=[logspace(-1,-.0001,300) logspace(.0001,1,300)]; g.line=0; s='k--';
g.style='b-';  Q=5;  Bode([1 0 1],[1 1/Q 1],g);
g.style='r-.'; Q=.5; Bode([1 0 1],[1 1/Q 1],g); subplot(2,1,1), axis([.1 10 .01 1])

% end script BodeTest