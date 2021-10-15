function Nyquist(num,den,g)                          % Numerical Renaissance Codebase 1.0
L=polyval(num,0)./polyval(den,0); plot(real(L),imag(L),'bo'); hold on; plot(-1,0,'k+');
L=polyval(num,i*g.omega)./polyval(den,i*g.omega);   plot(real(L),imag(L),'b-'); 
L=polyval(num,-i*g.omega)./polyval(den,-i*g.omega); plot(real(L),imag(L),'b-.');  
end % function Nyquist.m