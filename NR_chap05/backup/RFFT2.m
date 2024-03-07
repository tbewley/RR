function [uhat,vhat]=RFFT2(u,v,N)
% function [uhat,vhat]=RFFT2(u,v,N)
% INPUT: u and v are real arrays of order N=2^s.
% OUTPUT: uhat and vhat are complex arrays of order N/2, containing half of the FFTs
% of u and v, for wavenumbers 0 to N/2.  As u and v are real, their 0 and N/2 Fourier 
% coefficients are real, so the N/2 coefficients (at the Nyquist frequency) 
% are stored in the imaginary part of the the 0 coefficients.
% To remove them, just set, e.g., uhat(1)=real(uhat(1)).
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RFFT2inv, RFFT1, RFFT.  Verify with: RFFT2Test.

w=u+i*v;                                      % Combine u and v into a single complex
what=FFTdirect(w,N,-1);                       % vector and transform to Fourier space.
M=N+2;
for j=2:N/2
   uhat(j,1)=(what(j)+conj(what(M-j)))/2;     % Extract uhat and vhat from the result.
   vhat(j,1)=(what(j)-conj(what(M-j)))/(2*i);
end
uhat(1,1)=real(what(1)) +i*real(what(N/2+1)); % Handle the zero and Nyquist frequency
vhat(1,1)=imag(what(1)) +i*imag(what(N/2+1)); % separately, noting they are both real.
end % function RFFT2
