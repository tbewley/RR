function x=FFTdirect(x,N,g)
% function x=FFTdirect(x,N,g)
% Compute the forward FFT (g=-1) or inverse FFT (g=1) of a vector x of order N=2^s.
% At each stage, defining Ns=2^stage, the elements divide into N/Ns groups, each with Ns
% elements.  Each group is split in half and combined as in Fig 5.2.
% The corresponding wavenumber vector is:  k=(2*pi/L)*[[0:N/2]';[-N/2+1:-1]'].
% See <a href="matlab:RCweb">Numerical Renaissance: simulation, optimization, & control</a>, Section 5.4.1.
% Part of <a href="matlab:help RCC">Numerical Renaissance Codebase 1.0</a>, <a href="matlab:help RCchap05">Chapter 5</a>; please read the <a href="matlab:help RCcopyleft">copyleft</a>.
% See also FFTrecursive, FFTnonreordered.  Verify with: FFTdirectTest.

s=log2(N);              % number of stages 
ind=bin2dec(fliplr(dec2bin([0:N-1]',s))); x=x(ind+1); % Put input into bit reversed order.
for stage=1:s           % For each stage...
   Ns=2^stage;          % Determine size of the transform computed at this stage.
   M=Ns/2; w=exp(g*2*pi*i/Ns);  % Calculate w
   for m=0:M-1          % Split each group in half to combine as in Fig 5.2:
      wm=w^m;           % Calculate the necessary power of w.
      for n=1:Ns:N      % Determine each pair of elements to be combined and combine them.
         a=m+n; b=M+a; x([a b])=x(a)+[1; -1]*x(b)*wm;
      end
   end
end
if g==-1, x=x/N; end              % Scale the forward version of the transform by 1/N.
end % function FFTdirect
