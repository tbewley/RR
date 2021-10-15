function BodeDT(num,den,w,h,c,ep)                    % Numerical Renaissance Codebase 1.0
if nargin==5, extraphase=0; end, subplot(2,1,1)
loglog(w,abs(polyval(num,exp(i*w*h))./polyval(den,exp(i*w*h))),c)
a=axis; hold on, plot([a(1) a(2)],[1 1],'k--'), subplot(2,1,2)
semilogx(w,phase(polyval(num,exp(i*w*h))./polyval(den,exp(i*w*h)))*180/pi+ep,c)
a=axis; hold on, plot([a(1) a(2)],[-180 -180],'k--')
end % function BodeDT.m