function [u,v]=RFFT2inv(uhat,vhat,N)
% function [u,v]=RFFT2inv(uhat,vhat,N)
% INPUT: uhat & vhat are complex arrays of length N/2 containing half of the ffts of u & v,
% for wavenumbers 0 to N/2, with the N/2 coefficients stored in the imaginary part of the
% 0 coefficients.
% OUTPUT: u and v are real arrays of length N=2^s.
% This routine was written by inverting the steps of RFFT2 and doing them in reverse.
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.5.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RFFT2.  Verify with: RFFT2Test.

what(1)    =real(uhat(1)) +i*real(vhat(1)); 
what(N/2+1)=imag(uhat(1)) +i*imag(vhat(1));  
M=N+2;
for j=2:N/2
   what(j)   =uhat(j)+i*vhat(j);            % Combine uhat+i*vhat
   what(M-j)=conj(uhat(j))+i*conj(vhat(j));
end
w=FFTdirect(what,N,1);                      % Transform to physical space.
u=real(w)';  v=imag(w)';                    % Extract u and v from the result.
end % function RFFT2inv
