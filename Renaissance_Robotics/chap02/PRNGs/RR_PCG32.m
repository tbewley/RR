function out=RR_PCG32(n,s,skip)
% function out=RR_PCG32(n,s,skip)
% PRNG using Melissa O'Neill's Permuted Congruential Generator PCG32, with 64 bit state and
% 32 bit output for each stream; zillions of independent streams are possible, as is
% skipping forward/backard in any given stream.  NOTE: for code simplicity, multiple streams
% must be initialized in numerical order, but can be called in arbitrary order after that.
% Initialize with RR_prng('stochastic','PCG32') or RR_prng('deterministic','PCG32')
% This Matlab implementation is meant primarily for pedagogical purposes, it is not fast.
%
% INPUTS: n = number of pseudorandom numbers to generate               (OPTIONAL, n=1 by default)
%         s = which independent stream to pull random number from      (OPTIONAL, s=1 by default)
%         skip = number of steps to skip forward or backward in stream (OPTIONAL, skip=0 by default)
% TEST:   stream1=RR_PCG32(10)                   % Generate 10 pseudorandom numbers in stream s=1
%         stream2=RR_PCG32(20,2)                 % Generate 20 pseudorandom numbers in stream s=2
%         stream1_skipped_back=RR_PCG32(1,1,-10) % Skip backwards 10 steps in stream s=1
%         RR_prng('deterministic'); dec2hex(RR_PCG32(6)) % Round 1 of O'Neill's pcg32-demo code
%
% Dependencies: RR_prod32, RR_prod64, RR_sum64 (replace calls to these functions with simple
% * and + if converting to a language that can be set natively to wrap on integer overflow)
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin<1, n=1; end     % number of pseudorandom numbers to generate
if nargin<2, s=1; end     % which stream to operate in
if nargin<3, skip=0; end  % number of elements to skip in the stream

global RR_PRNG_GENERATOR RR_PRNG_x RR_PRNG_c
if ~strcmp(RR_PRNG_GENERATOR,'PCG32'), RR_prng('stochastic','PCG32'), end

if length(RR_PRNG_x)<s     % Initialization (if required) of {state,inc} for stream s>1
  if length(RR_PRNG_x)<s-1, error('RR_PCG32 streams must be initialized sequentially')
  else  % initialize x and c of stream s>1 based on x and c of stream s-1
      % takes a=dec2hex(uint64(a)) for a=3935559000370003845 and 2685821657736338717 from L’Ecuyer (1999) 
      RR_PRNG_x(s)=RR_sum64(RR_prod64(RR_PRNG_x(s-1),  0x369DEA0F31A53F85),1); % initialize x(s) using x(s-1)
      RR_PRNG_c(s)=RR_sum64(RR_prod64(RR_PRNG_c(s-1)-1,0x2545F4914F6CDD1D),1); % subtract/add 1, keeps c(s) odd
  end
end
xold=RR_PRNG_x(s); % Prep to calculate using local values {xold,xnew} (faster)

% Below is the RR implementation of the skip algorithm by Forrest Brown (1994),
% as summarized at https://mcnp.lanl.gov/pdf_files/TechReport_2007_LANL_LA-UR-07-07961_Brown.pdf
% Noting that x_{n+k}=A*x_n+C, we first need to calculate A=mod(a^k,2^m) and C=mod(c*(a^k-1)/(a-1),2^m) 
% We use astar and cstar instead of a and c to skip backwards, reducing the number of steps required.
if skip~=0
   A=uint64(1); C=uint64(0); ib=dec2bin(abs(skip)); imax=length(ib);
   if skip>0, h=0x5851F42D4C957F2D; f=RR_PRNG_c(s);
   else,      h=0xC097EF87329E28A5; f=RR_prod64(RR_PRNG_c(s),0x3F681078CD61D75B); end % <- new idea!
   for i=imax:-1:1,  if str2num(ib(i)),  A=RR_prod64(A,h);  C=RR_sum64(RR_prod64(C,h),f);  end
   f=RR_prod64(f,RR_sum64(h,uint64(1))); h=RR_prod64(h,h);  end
   xold=RR_sum64(RR_prod64(A,xold),C);  % <- Do the actual skip here
end

% Below is the RR implementation of the PCG32 (XSH_RR) algorithm by Melissa O'Neill (2014)
for i=1:n
  xnew=RR_sum64(RR_prod64(0x5851F42D4C957F2D,xold),RR_PRNG_c(s)); % Update state of LCG for stream s
  % Then, calculate a 32-bit PCG output (based on xold, for better instruction-level parallelism)
  temp   = uint32(bitand(bitsra(bitxor(bitsra(xold,18),xold),27),0xFFFFFFFFu64));
  rot    = uint32(bitsra(xold,59));
  out(i) = bitor(bitsra(temp,rot),bitsll(temp,(bitand(bitcmp(rot)+1,31))));
  xold=xnew;
end

RR_PRNG_x(s)=xnew;  % Save current value of state for next time

% Note above that a=0x5851F42D4C957F2D, astar=0xC097EF87329E28A5, and minus_astar=0x3F681078CD61D75B
% astar was found by solving z*2^m+a*astar=g (with g=1), using [g,z,astar]=RR_bezout(RR_uint64(0),a)
% minus_astar was found by calculating bitcmp(astar)+1
