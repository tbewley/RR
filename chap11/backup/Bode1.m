function Bode(num,den,w,c,extraphase)                % Numerical Renaissance Codebase 1.0
if nargin==4, extraphase=0; end
subplot(2,1,1), loglog(w,abs(polyval(num,i*w)./polyval(den,i*w)),c)
a=axis; hold on; plot([a(1) a(2)],[1 1],'k--')
subplot(2,1,2), semilogx(w,phase(polyval(num,i*w)./polyval(den,i*w))*180/pi+extraphase,c)
end % function Bode.m