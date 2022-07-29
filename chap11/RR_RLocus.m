function RLocus(numG,denG,numD,denD,g)
% function RLocus(numG,denG,numD,denD,g)
% Plot root locus of K*D(s)*G(s) w.r.t. the extra gain K, where D(s)=numD(s)/denD(s) and
% G(s)=numG(s)/denG(s).  The derived type g groups together convenient plotting parameters:
% g.K is the gains used, and g.axes is the axis limits.  The roots for K=1 are marked (*).
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 18.1.1.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap18">Chapter 18</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help RLocusTest">RLocusTest</a>.  Depends on <a href="matlab:help PolyVal">PolyVal</a>.

[numL,denL]=RationalSimplify(PolyConv(numG,numD),PolyConv(denG,denD));
MS='MarkerSize'; clf, hold on
for j=1:length(g.K); denH=PolyAdd(g.K(j)*numL,denL);
  Hpoles=roots(denH); plot(real(Hpoles),imag(Hpoles),'k.',MS,10)
end, 
Gpoles=roots(denG); plot(real(Gpoles),imag(Gpoles),'kx',MS,17)
Gzeros=roots(numG); plot(real(Gzeros),imag(Gzeros),'ko',MS,12)
Dpoles=roots(denD); plot(real(Dpoles),imag(Dpoles),'bx',MS,17)
Dzeros=roots(numD); plot(real(Dzeros),imag(Dzeros),'bo',MS,12)
Hpoles=roots(PolyAdd(numL,denL)); plot(real(Hpoles),imag(Hpoles),'r*',MS,17)
axis equal, a=g.axes; axis(a), plot([a(1) a(2)],[0 0],'k-'), plot([0 0],[a(3) a(4)],'k-')
end % function RLocus
