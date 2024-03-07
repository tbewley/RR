function [x] = RC_FFTrecursive(x,N,g)
% function [x] = RC_FFTrecursive(x,N,g)
% Compute the forward FFT (g=-1) or inverse FFT (g=1) of a vector x of order N=2^s.  The
% entire algorithm is simply repeated application of Eqn (5.20).   NOTE: to get the
% forward transform, you must divide the result by N outside this function. Note also that
% the wavenumber vector corresponding to the Fourier representation should be defined
% (outside this routine) as:  k=(2*pi/L)*[[0:N/2]';[-N/2+1:-1]']; note in particular that
% k(1)=0 (recall that Matlab indexes from 1, not 0).
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.4.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also RC_FFTdirect, RC_FFTnonreordered. Depends on <a href="matlab:help RC_FFTrecursive">FFTrecursive</a> (that is, it's recursive...)
% Verify with: RC_FFTrecursiveTest.
                                                                                                       
if N>1                                        % If N=1, do nothing, else...
   M=N/2; w=exp(g*2*pi*i/N); xe=x(1:2:N-1); xo=x(2:2:N);
   xe=RC_FFTrecursive(xe,M,g);                % Compute FFTs of the even and odd parts.
   xo=RC_FFTrecursive(xo,M,g); 
   for j=1:M; xo(j,1)=w^(j-1)*xo(j,1); end    % Split each group in half and combine
   x=[xe+xo; xe-xo];                          % as in Eqn (5.25)
end
end % function RC_FFTrecursive
