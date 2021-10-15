function NyquistDT(num,den,h,w)                      % Numerical Renaissance Codebase 1.0
L=polyval(num,exp( i*w*h))./polyval(den,exp(i*w*h));  plot(real(L),imag(L),'b-'), hold on
L=polyval(num,exp(-i*w*h))./polyval(den,exp(-i*w*h)); plot(real(L),imag(L),'b-.')
L=polyval(num,0)./polyval(den,0); plot(real(L),imag(L),'bo'), plot(-1,0,'k+')
end % function NyquistDT.m