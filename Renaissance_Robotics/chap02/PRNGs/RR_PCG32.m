function [out,X]=RR_PCG32(num,stream,skip)
% function [out,X]=RR_PCG32(num,stream,skip)
% PRNG using Melissa O'Neill's Permuted Congruential Generator PCG32, with 64 bit state and 32 bit output for
% each stream; zillions of independent streams are possible, as is skipping forward/backard in any given stream.
% NOTE: for code simplicity, multiple streams must be initialized in numerical order,
% but they can be called in arbitrary order after that.
% Initialization is based on the number of microseconds since midnight on New Years Eve in 2023.
% INPUT: num = number of pseudorandom numbers to generate                 (OPTIONAL, num=1 by default)
%        stream = which independent stream to pull random number from     (OPTIONAL, stream=1 by default)
%        skip = the number of steps to skip forward or backward in stream (OPTIONAL, skip=0   by default)
% TEST:  RR_PCG32(5,1)     % Generate 5 pseudorandom numbers in stream 1
%        RR_PCG32(5,2)     % Generate 5 pseudorandom numbers in stream 2
%        RR_PCG32(5,1)     % Generate 5 more pseudorandom numbers in stream 1
%        RR_PCG32(1,1,-10)  % Skip backwards 10 steps in stream 1 (recovers first random number generated previously)
%        clear RR_PCG32, for i=1:100, RR_PCG32(1,i); end  % inspect the random initilization of 100 streams
%        % The following test recovers the 32bit output (in hex) of Round 1 of O'Neill's pcg32-demo code
%        clear RR_PCG32; dec2hex(RR_PCG32(6,0))  
% DEPENDENCIES: This Matlab code depends, internally, on the RR_uint64 class defined by:
%   https://github.com/tbewley/RR/blob/main/Renaissance_Robotics/chapAA/classes/RR_uint64.m
% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Efficient PCG algorithm (in C and C++) due to Melissa O'Neill, available at
%%    https://www.pcg-random.org/download.html 
%% Matlab implementation Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.
%% (This Matlab implementation is meant primarily for pedagogical purposes, it is not fast.)

persistent a astar  % initialize {a,astar} (forward and backward multipliers) just once, and keep "persistent"
persistent x c % hold RR_uint64 variables x (state) and c (increment) as "persistent" for each stream of RR_PCG
if nargin==0, num=1;    end                   % number of pseudorandom numbers to generate
if nargin<2,  stream=1; end, s=max(stream,1); % note: stream=0 test case actually makes use of stream=1

if length(x)<s       % INITIALIZATION OF {state,inc} FOR THIS STREAM
  if length(x)==0;
    x={}; inc={}; a=RR_uint64(0x5851F42D4C957F2D); % set up x, inc, O'Neill's multiplier a, and astar, noting
              astar=RR_uint64(0xC097EF87329E28A5); % that astar was found by solving z*2^m+a*astar=g (with g=1),
  end                                              % which was done using [g,z,astar] = RR_bezout(RR_uint64(0),a);
  if s>1 & length(x)<s-1, error('RR_PCG streams must be initialized sequentially'), end
  switch stream
    case 0, disp('Initializing some deterministic values of {x,c}, for TEST PURPOSES ONLY')
      x{1} = RR_uint64(151);  % Generates values identical to Round 1
      c{1} = RR_uint64(109);  % of O'Neill's pcg32-demo.c code
    case 1, % initialize stream s=1 based on the number of microseconds since midnight on 31 Dec 2023
      x{1} = RR_uint64(convertTo(datetime,'epochtime','Epoch','1-Jan-2024','TicksPerSecond',1e6));
      c{1} = RR_uint64(bin2dec(fliplr(dec2bin(x{1}.v,50))))*0x372AAF131886F61A;
      x{1} = x{1}*0x2545F4914F6CDD1D; c{1}.v=bitset(c{1}.v,1);
      fprintf('Initializing PCG stream   1 with state x=%20u and odd increment=%20u\n',x{1}.v,c{1}.v)
    otherwise % initialize x_old and c of stream s>1 based on x and c of stream s-1
      % note: takes a=dec2hex(uint64(a)) for a=3935559000370003845 and 2685821657736338717 from L’Ecuyer (1999) 
      x{s} =  x{s-1}   *0x369DEA0F31A53F85+1; % initialize x{s} using x{s-1}
      c{s} = (c{s-1}-1)*0x2545F4914F6CDD1D+1; % (subtracting/adding 1 keeps each c{s} odd)
    fprintf('Initializing PCG stream %3d with state x=%20u and odd increment=%20u\n',s,x{s}.v,c{s}.v)
  end
end

% IMPLEMENT SKIP ALGORITHM from Forrest Brown (1994) Random number generation with arbitrary strides,
% as summarized at https://mcnp.lanl.gov/pdf_files/TechReport_2007_LANL_LA-UR-07-07961_Brown.pdf
% Noting that x_{n+k}=A*x_n+C, we first need to calculate A=mod(a^k,2^m) and C=mod(c*(a^k-1)/(a-1),2^m) 
% Also, we use astar and cstar instead of a and c to skip backwards, reducing the number of steps required.
if nargin==3 & skip~=0
   A=RR_uint64(1); C=RR_uint64(0); ib=dec2bin(abs(skip)); imax=length(ib);
   if skip>0, h=a; f=c{s}; else, h=astar; f=c{s}*(-astar); end, 
   for i=imax:-1:1, if str2num(ib(i)), A=A*h; C=C*h+f; end, f=f*(h+1); h=h*h; end
   x{s}=A*x{s}+C;   % Do the skip 
end

for i=1:num
  x{s}=a*x{s}+c{s};   % UPDATE INTERNAL 64-BIT STATE of LCG for stream s

  % Finally, calculate a 32-bit PCG output using O'Neill's XSH_RR output bit permutations.
  % See section 6.3.1 of https://www.pcg-random.org/pdf/hmc-cs-2014-0905.pdf 
  temp   = uint32(bitand(bitsra(bitxor(bitsra(x{s}.v,18),x{s}.v),27),0x00000000FFFFFFFF));
  rot    = uint32(bitsra(x{s}.v,59));
  out(i) = bitor(bitsra(temp,rot),bitsll(temp,(bitand(bitcmp(rot)+1,31))));
end

if nargout==2, X=x{s}; end  % If requested, also return current internal state (which usually stays hidden...)
