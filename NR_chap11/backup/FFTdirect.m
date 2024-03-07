function y=FFTdirect(x,N,g)                          % Numerical Renaissance Codebase 1.0
% Compute the forward FFT (g=-1) or inverse FFT (g=1) of a vector x of order N=2^s. 
% At each stage, defining Ns=2^stage, the elements divide into N/Ns groups, each
% with Ns elements.  Each group is split in half and combined as in Fig 4.2.
% Note that the wavenumber vector corresponding to the Fourier representation
% should be defined (outside this routine) as:  k=(2*pi/L)*[[0:N/2]';[-N/2+1:-1]'];
s=log2(N);                   % number of stages 
ind=bin2dec(fliplr(dec2bin([0:N-1]',s)));
y=x(ind+1);                  % Reorder the input values into bit reversed order
for stage=1:s                % For each stage...
   Ns=2^stage;               % Determine size of the transform computed at this stage
   M=Ns/2; w=exp(g*2*pi*i/Ns);  % Calculate w
   for m=0:M-1               % Split each group in half to combine as in Fig 4.2:
      wm=w^m;                % Calculate the necessary power of w.
      for n=1:Ns:N           % Loop over the different groups.
         a=m+n; b=M+a;       % Determine each pair of elements to be combined...
         y([a b])=y(a)+[1; -1]*y(b)*wm;     % ... and combine them.
      end
   end
end 
if g==-1, y=y/N; end         % Scale the forward version of the transform by 1/N.
end % function FFTdirect
