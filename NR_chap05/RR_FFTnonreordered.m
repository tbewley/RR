function x=RC_FFTnonreordered(x,N,g)
% function x=RC_FFTnonreordered(x,N,g)
% Compute the FFT (g=-1) or inverse FFT (g=1) of a vector x of order N=2^s.  NOTE: as
% opposed to Algorithm 5.2, this algorithm does not bother reordering the Fourier
% representation out of, and then back into, bit reversed order, thereby reducing both
% storage and execution time (see Figure 5.3).  The corresponding wavenumber vector is
% t=(2*pi/L)*[[0:N/2]';[-N/2+1:-1]']; k=t(1+bin2dec(fliplr(dec2bin([0:N-1]',s))))
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.4.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also FFTrecursive, FFTdirect.  Verify with: FFTnonreorderedTest.

s=log2(N);       % Number of stages.
if g==-1         % FORWARD TRANSFORM (physical space input expected in standard order).
  for stage=1:s  % (This section similar to Algorithm 5.2, modified as in Figure 5.3.)        
    Ns=2^stage; d=2*N/Ns; M=N/Ns; w=exp(-2*pi*i/Ns);  
    wv=w.^(bin2dec(fliplr(dec2bin([0:Ns/2-1]))));           % Bitswap the exponent vector.
    for m=0:Ns/2-1            
      md=m*d;
      for n=1:M  % Determine each pair of elements to be combined, and combine them.
        a=md+n; b=a+M; x([a b])=x(a)+[1; -1]*x(b)*wv(m+1);
      end
    end
  end            % Note: Fourier space output is returned in bit reversed order.
  x=x/N;
else             % INVERSE TRANSFORM (Fourier space input expected in bit reversed order).
  for stage=1:s  % (This section as in Algorithm 5.2.)             
    Ns=2^stage; M=Ns/2; w=exp(2*pi*i/Ns); wv=w.^([0:Ns/2-1]);  % Standard order used here.
    for m=0:M-1
      for n=1:Ns:N  
        a=m+n; b=a+M; x([a b])=x(a)+[1; -1]*x(b)*wv(m+1);
      end
    end
  end            % Note: Physical space output is returned in standard order.
end
end % function RC_FFTnonreordered
