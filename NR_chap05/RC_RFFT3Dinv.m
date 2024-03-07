function [u]=RFFT3Dinv(uhat,NX,NY,NZ)
% function [u]=RFFT3Dinv(uhat,NX,NY,NZ)
% Compute the inverse 3D FFT of the input uhat.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.10.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RFFT3D.  Verify with: RFFT3Dtest.

if NZ>1; for I=1:NX/2; for J=1:NY; uhat(I,J,:)=RC_FFTdirect(uhat(I,J,:),NZ,1); end; end; end
for I=1:NX/2; for K=1:NZ;          uhat(I,:,K)=RC_FFTdirect(uhat(I,:,K),NY,1); end; end;
for J=1:NY;   for K=1:NZ;          u   (:,J,K)=RC_RFFTinv  (uhat(:,J,K),NX);   end; end;
end % function RFFT3Dinv
