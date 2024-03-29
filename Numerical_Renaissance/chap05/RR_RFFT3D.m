function [uhat]=RR_RFFT3D(u,NX,NY,NZ)
% function [uhat]=RR_RFFT3D(u,NX,NY,NZ)
% Compute the 3D FFT of the input u, setting all oddball wavenumber coefficients
% equal to zero.  Note that this code was written to emphasize the simplicity of this
% operation: more efficient codes would involve many fewer function calls by using
% specialized versions of RFFT and FFTdirect that compute many FFTs simultaneously. 
% This code also computes the 2D FFT of u if NZ=1.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.10.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RFFT3Dinv, RFFT.  Trial: RFFT3Dtest.

for J=1:NY,   for K=1:NZ, uhat(:,J,K)=RR_RFFT(u(:,J,K),NX); end, end
uhat(1,:,:)=real(uhat(1,:,:)); 
for I=1:NX/2, for K=1:NZ, uhat(I,:,K)=RR_FFTdirect(uhat(I,:,K),NY,-1); end, end
uhat(:,NY/2+1,:)=0; 
if NZ>1;
  for I=1:NX/2, for J=1:NY, uhat(I,J,:)=RR_FFTdirect(uhat(I,J,:),NZ,-1); end, end
  uhat(:,:,NZ/2+1)=0; 
end
end % function RR_RFFT3D
