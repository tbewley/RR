function [uhat]=RFFT1(u,N)
% function [uhat]=RFFT1(u,N)
% INPUT: u is a real array of length N=2^s.
% OUTPUT: uhat is a complex array of length N/2.  It contains half of the fft of u,
% for the wavenumbers 0 to N/2.  As u is real, its 0 and N/2 coefficients are real,
% so the N/2 coefficient (at the "oddball wavenumber") is stored in the imaginary
% part of the the 0 coefficient.  To remove it, just set uhat(1)=real(uhat(1)).
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RFFT1inv, RFFT2, RFFT.  Verify with: RFFT1Test.

[uehat,uohat]=RFFT2(u(1:2:N-1),u(2:2:N),N/2);  % Compute FFTs of the even and
M=N/2+2;                                       % odd parts of u
for n=2:N/4
  uhat(n,1)  =    (uehat(n)+exp(-2*pi*i*(n-1)/N)*uohat(n))/2;  % Combine result
  uhat(M-n,1)=conj(uehat(n)-exp(-2*pi*i*(n-1)/N)*uohat(n))/2;  % as in Eqn 4.29
end
uhat(1,1)=(real(uehat(1))+real(uohat(1)))/2 + i*(real(uehat(1))-real(uohat(1)))/2;
uhat(N/4+1,1)=(imag(uehat(1))-i*imag(uohat(1)))/2;
end % function RFFT1
