function [out,X]=RR_PCG32(stream,skip)
% function out=RR_PCG32(stream,skip)
% PRNG using Melissa O'Neill's Permuted Congruential Generator PCG32, with 64 bit state and 32 bit output for
% each stream; zillions of independent streams are possible, as is skipping forward/backard in any given stream.
% NOTE: for code simplicity, multiple streams  must be initialized in numerical order,
% but they can be called in arbitrary order after that.
% Initialization is based on the number of microseconds since midnight on New Years Eve in 2023.
% INPUT: stream = which independent stream to pull random number from     (OPTIONAL, stream=1 by default)
%        skip = the number of steps to skip forward or backward in stream (OPTIONAL, skip=0   by default)
% TEST:  RR_PCG32(1), RR_PCG32(1), RR_PCG32(1)  % Begin stream 1
%        RR_PCG32(2), RR_PCG32(2), RR_PCG32(2)  % Begin stream 2
%        RR_PCG32(1), RR_PCG32(1), RR_PCG32(1)  % continue random sequence in stream 1
%        RR_PCG32(1,-6) % skip backwards 6 steps in PCG stream 1 (recovers first random number generated above)
%        clear RR_PCG32, for i=1:100, RR_PCG32(i); end  % inspect the random initilization of 100 streams
%        % The following test recovers the 32bit output (in hex) of Round 1 of O'Neill's pcg32-demo code
%        clear RR_PCG32; for i=1:6, dec2hex(RR_PCG32(0)), end  
% DEPENDENCIES: This Matlab code depends, internally, on the RR_uint64 class defined by:
%   https://github.com/tbewley/RR/blob/main/Renaissance_Robotics/chapAA/classes/RR_uint64.m
% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Efficient PCG algorithm (in C and C++) due to Melissa O'Neill, available at
%%    https://www.pcg-random.org/download.html 
%% Matlab implementation Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.
%% (This Matlab implementation is meant primarily for pedagogical purposes, it is not fast.)

persistent a astar  % initialize {a,astar} (forward and backward multipliers) just once
persistent x c % hold RR_uint64 variables x (state) and c (increment) as "persistent" for each stream of RR_PCG
if nargin==0, stream=1, end, s=max(stream,1);  % note: stream=0 test case makes use of stream=1

if length(x)<s       % INITIALIZATION OF {state,inc} FOR THIS STREAM
  if length(x)==0;
    x={}; inc={}; a=RR_uint64(0x5851F42D4C957F2D) % set up x, inc, a
              astar=RR_uint64(0xC097EF87329E28A5) % astar was found by solving z*2^m+a*astar=g (with g=1),
  end                                             % which was done using [g,z,astar] = RR_bezout(RR_uint64(0),a);
  if s>1 & length(x)<s-1, error('RR_PCG streams must be initialized sequentially'), end
  switch stream
    case 0, disp('Initializing some deterministic values of {x,c}, for TEST PURPOSES ONLY')
      x_old = RR_uint64(0x185706B82C2E03F8); % Generates values identical to Round 1
      c{1}  = RR_uint64(109);                % of O'Neill's pcg32-demo.c code
    case 1, % initialize stream s=1 based on the number of microseconds since midnight on 31 Dec 2023
      x_old = RR_uint64(convertTo(datetime,'epochtime','Epoch','1-Jan-2024','TicksPerSecond',1e6));
      c{1}  = RR_uint64(bin2dec(fliplr(dec2bin(x_old.v,50))))*0x372AAF131886F61A;
      x_old = x_old*0x2545F4914F6CDD1D; c{1}.v=bitset(c{1}.v,1);
      fprintf('Initializing PCG stream   1 with x_old=%20u and odd increment=%20u\n',x_old.v,c{1}.v)
    otherwise % initialize x_old and c of stream s>1 based on x and c of stream s-1
      % note: take a=dec2hex(uint64(a)) for a=3935559000370003845 and 2685821657736338717 from L’Ecuyer (1999) 
      x_old = x{s-1} *0x369DEA0F31A53F85+1;    % initialize x{s} using x{s-1}
      c{s}  = (c{s-1}-1)*0x2545F4914F6CDD1D+1; % (subtracting/adding 1 keeps each c{s} odd)
    fprintf('Initializing PCG stream %3d with x_old=%20u and odd increment=%20u\n',s,x_old.v,c{s}.v)
  end
else 
  x_old=x{s};  % Continuing computation in stream s 
end

% IMPLEMENT SKIP ALGORITHM from Forrest Brown (1994) Random number generation with arbitrary strides,
% as summarized at https://mcnp.lanl.gov/pdf_files/TechReport_2007_LANL_LA-UR-07-07961_Brown.pdf
% Noting that x_{k_n}=A*x_n+C, we first need to calculate A=mod(a^k,2^m) and C=mod(c*(a^k-1)/(a-1),2^m) 
% Use astar and cstar instead of a and c if skipping backwards (reduces the number of steps used!)
if nargin==2 & skip~=0
   A=RR_uint64(1); C=RR_uint64(0); ib=dec2bin(abs(skip)); imax=length(ib);
   if skip>0, h=a; f=c{s}; else, h=astar; f=c{s}*(-astar); end, 
   for i=imax:-1:1, if str2num(ib(i)), A=A*h; C=C*h+f; end, f=f*(h+1); h=h*h; end
   x_old=A*x_old+C;   % Do the skip 
end

x{s}=a*x_old+c{s};   % UPDATE INTERNAL 64-BIT STATE of LCG for this stream

% Finally, calculate the 32-bit PCG output using O'Neill's XSH_RR output bit permutations.
% See section 6.3.1 of https://www.pcg-random.org/pdf/hmc-cs-2014-0905.pdf 
out = uint32(bitand(bitsra(bitxor(bitsra(x_old.v,18),x_old.v),27),0x00000000FFFFFFFF));
rot = uint32(bitsra(x_old.v,59));
out = bitor(bitsra(out,rot),bitsll(out,(bitand(bitcmp(rot)+1,31))));

if nargout==2, X=x{s}; end  % If requested, also return current state

% For comparison to O'Neill's PCG code, here are some bitwise operations on integers, in both C and Matlab:
% Bit Operation  C      Matlab
% -------------------------------
% rightshift    a>>k  bitsra(a,k)
% leftshift     a<<k  bitsll(a,k)
%    AND        a&b   bitand(a,b)
%    XOR        a^b   bitxor(a,b)
%    OR         a|b   bitor(a,b)
% 2's comp.     -a    bitcmp(a)+1