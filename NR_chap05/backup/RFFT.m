function [uh]=RFFT(u,N)
% function [uh]=RFFT(u,N)
% This routine was written by substituting RFFT2.m into RFFT1.m and simplifying.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RFFTinv, RFFT1, RFFT2.  Verify with: RFFTtest.

wh=FFTdirect(u(1:2:N-1)+i*u(2:2:N),N/2,-1);
M=N/2+2;
for n=2:N/4
  uh(n,1)  =(wh(n)+conj(wh(M-n))-i*exp(-2*pi*i*(n-1)/N)*(wh(n)-conj(wh(M-n))))/4;
  uh(M-n,1)=(conj(wh(n))+wh(M-n)-i*exp( 2*pi*i*(n-1)/N)*(conj(wh(n))-wh(M-n)))/4;
end
uh(1,1)=(real(wh(1))+imag(wh(1)))/2 + i*(real(wh(1))-imag(wh(1)))/2;
uh(N/4+1,1)=(real(wh(N/4+1))-i*imag(wh(N/4+1)))/2;
end % function RFFT
