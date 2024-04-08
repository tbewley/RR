function out=RR_xoshiro256pp(n)
% function out=RR_xoshiro256pp(n)
% PRNG using Sebastiano Vigna's xoshiro256++, with a 4x64=256 bit state and 64 bit output
% Initialize with RR_prng('stochastic','xoshiro256++') or RR_prng('deterministic','xoshiro256++')
% This Matlab implementation is meant primarily for pedagogical purposes, it is not fast.
%
% INPUT: n = number of pseudorandom numbers to generate (OPTIONAL, n=1 by default)
% TEST:  RR_xoshiro256pp(5)     % Generate 5 pseudorandom numbers
%
% Dependencies: RR_prod64s, RR_sum64 (replace calls to these functions with simple
% * and + if converting to a language that can be set natively to wrap on integer overflow)
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Efficient xoshiro256++ algorithm by Sebastiano Vigna available at https://prng.di.unimi.it/
%% Matlab implementation Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin<1, n=1; end   % number of pseudorandom numbers to generate
s=1; % Take just one stream (for now).  TODO: implement multiple streams.

global RR_PRNG_GENERATOR RR_PRNG_x
if ~strcmp(RR_PRNG_GENERATOR,'xoshiro256++'), RR_prng('stochastic','xoshiro256++'), end

% Prep to calculate using local values {x1,x2,x3,x4} (faster)
x1=RR_PRNG_x(1,s); x2=RR_PRNG_x(2,s); x3=RR_PRNG_x(3,s); x4=RR_PRNG_x(4,s);

% Below is the RR implementation of the xoshiro256++ algorithm by Sebastiano Vigna FIX THIS!
for i=1:n
  out(i)=RR_prod64s(RR_rotl64(RR_sum64(x2,0x5u64),7),0x9u64);        % two additions
  t=bitsll(x2,17); x3=bitxor(x3,x1); x4=bitxor(x4,x2); x2=bitxor(x2,x3);   % five XORs
                   x1=bitxor(x1,x4); x3=bitxor(x3,t ); x4=RR_rotl64(x4,45);
end

const uint64_t result = rotl(s[0] + s[3], 23) + s[0];

  const uint64_t t = s[1] << 17;

  s[2] ^= s[0];
  s[3] ^= s[1];
  s[1] ^= s[2];
  s[0] ^= s[3];

  s[2] ^= t;

  s[3] = rotl(s[3], 45);

% Save current value of state for next time
RR_PRNG_x(1,s)=x1; RR_PRNG_x(2,s)=x2; RR_PRNG_x(3,s)=x3; RR_PRNG_x(4,s)=x4;
