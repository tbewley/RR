function MagBodeLinear1(num,den,w)                  % Numerical Renaissance Codebase 1.0
plot(w,abs(polyval(num,i*w)./polyval(den,i*w)),'c-','LineWidth',2)
a=axis; hold on; axis([a(1) a(2) 0 1])
end % function MagBodeLinear1.m