function MagBodeLinear(num,den,w,wc,c)                % Numerical Renaissance Codebase 1.0
plot(w,abs(polyval(num,i*w/wc)./polyval(den,i*w/wc)).^2,c)
a=axis; hold on; plot([a(1) a(2)],[1 1],'k--')
end % function MagBodeLinear.m