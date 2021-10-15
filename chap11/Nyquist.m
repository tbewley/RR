function Nyquist(num,den,g)
% function Nyquist(num,den,g)
% Draw the Nyquist plot (i.e., a Bode plot in polar coordinates) of G(s)=num(s)/den(s).
% The derived type g groups together convenient plotting parameters: g.omega is the set of
% frequencies used, g.style is the linestyle, {g.figs,g.figL} are the figure numbers, and,
% in the s plane, g.eps is the (small) radius of the half-circles to the right of each
% pole on the imaginary axis, and g.R is the (large) radius of the D contour.
% Practical recommendation: do not make g.eps too small, or g.R too big, until you see
% where the corresponding curves are in both the s plane and the L plane!
% See <a href="matlab:NRweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 18.1.3.
% Part of <a href="matlab:help NRC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help NRchap18">Chapter 18</a>; please read the <a href="matlab:help NRcopyleft">copyleft</a>.
% Verify with: <a href="matlab:help NyquistTest">NyquistTest</a>.  Depends on <a href="matlab:help PolyVal">PolyVal</a>.

L=PolyVal(num,0)./PolyVal(den,0); P=Roots(den); Z=Roots(num); tol=.0001;  
figure(g.figs), clf, plot(real(P),imag(P),'kx'), hold on, plot(real(Z),imag(Z),'ko') 
figure(g.figL), clf, plot(-1,0,'k+'),            hold on, plot(real(L),imag(L),'bo')
% First, find and sort the poles of D(s)*G(s) on the imaginary axis.
k=0; for j=1:length(P); if abs(real(P(j)))<tol, k=k+1; iP(k,1)=imag(P(j)); end, end
iP=QuickSort(iP,0,k); iPu(1)=iP(1); k=1;   
for j=2:length(iP); if abs(iP(j)-iPu(k))>tol, k=k+1; iPu(k)=iP(j); end, end
% Draw small half circles in the s-plane to the right of each pole on the imaginary axis. 
for j=1:k, w=i*iPu(j)+g.eps*exp(-i*[-pi/2:pi/50:pi/2]);
  if sign(iPu(j))<0, sym='r--'; else, sym='r-'; end, L=PolyVal(num,w)./PolyVal(den,w);
  figure(g.figs), plot(real(w),imag(w),sym), figure(g.figL), plot(real(L),imag(L),sym)
end
% Next, draw the (large) D contour in the s-plane.
w=g.R*exp(-i*[-pi/2:pi/50:pi/2]); L=PolyVal(num,w)./PolyVal(den,w); sym='k-.';
figure(g.figs), plot(real(w),imag(w),sym), figure(g.figL), plot(real(L),imag(L),sym)
% Finally, draw the line going up the imaginary axis in the s-plane (in several segments)
a(1)=-g.R; b=[];          % [note: segment j goes from a(j) to b(j)] 
for j=1:ceil(k/2),        b=[b iPu(j)-g.eps]; a=[a iPu(j)+g.eps]; end
if floor(k/2)==ceil(k/2), b=[b -1e-12];       a=[a 1e-12];        end
for j=ceil(k/2)+1:k,      b=[b iPu(j)-g.eps]; a=[a iPu(j)+g.eps]; end, b=[b g.R];
for j=1:length(a), w=i*logspace(log10(abs(a(j))),log10(abs(b(j))),1000);
  if sign(b(j))<1, w=-w; sym='b--'; else, sym='b-'; end, L=PolyVal(num,w)./PolyVal(den,w);
  figure(g.figs), plot(real(w),imag(w),sym), figure(g.figL), plot(real(L),imag(L),sym)
end
end % function Nyquist
