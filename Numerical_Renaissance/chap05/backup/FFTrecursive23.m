function [x] = FFTrecursive(x,N,g)
% Compute the forward FFT (g=-1) or inverse FFT (g=1) of a vector x of order N=2^s.  The
% entire algorithm is simply repeated application of Eqn (5.20).   NOTE: to get the
% forward transform, you must divide the result by N outside this function. Note also that
% the wavenumber vector corresponding to the Fourier representation should be defined
% (outside this routine) as:  k=(2*pi/L)*[[0:N/2]';[-N/2+1:-1]']; note in particular that
% k(1)=0 (recall that Matlab indexes from 1, not 0).
if N>1                                           % If N=1, do nothing, else...
   M=N/2; w=exp(g*2*pi*i/N); xe=x(1:2:N-1); xo=x(2:2:N);
   xe=FFTrecursive(xe,M,g);                      % Compute FFTs of the even and odd parts.
   xo=FFTrecursive(xo,M,g); 
   for j=1:M; xo(j,1)=w^(j-1)*xo(j,1); end       % Split each group in half and combine
   x=[xe+xo; xe-xo];                             % as in Eqn (5.22)
end

w3=exp(g*2*pi*i/3);w3b=conj(w3);
if N>1                                           % If N=1, do nothing,
else...
  if mod(N,2)==0                                % Factoring by 2 (if possible) until N=3^t or N=1
    M=N/2; w=exp(g*2*pi*i/N); xe=x(1:2:N-1); xo=x(2:2:N);
    xe=FFTrecursive23b(xe,M,g);              % Compute FFTs of the even and odd parts.
    xo=FFTrecursive23b(xo,M,g);
    for j=1:M; xo(j,1)=w^(j-1)*xo(j,1); end       % Split each group in half and combine
    x=[xe+xo; xe-xo];                             % as in Eqn (5.22)
  else                                            % when finishing factoring by 2, we factor by 3 if needed
    M=N/3; w=exp(g*2*pi*i/N);
    xa=x(1:3:N-2);xb=x(2:3:N-1);xc=x(3:3:N);
    xa=FFTrecursive23b(xa,M,g);
    xb=FFTrecursive23b(xb,M,g);                   % Compute FFTs of the a,b,c parts
    xc=FFTrecursive23b(xc,M,g);
    for j=1:M;                                    % multiplication B*c in (5.33)
        xb(j,1)=w^(j-1)*xb(j,1);
        xc(j,1)=(w^(j-1))^2*xc(j,1);
    end
    x=[xa+xb+xc; xa+w3*xb+w3b*xc; xa+w3b*xb+w3*xc];  % multiplication A*(Bc) in (5.33)
  end

end % function FFTrecursive.m
