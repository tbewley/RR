function out=RR_xoroshiro128ss(n)
% function out=RR_xoroshiro128ss(n)
% PRNG using Sebastiano Vigna's xoroshiro128**, with a 4x32=128 bit state and 32 bit output
% Initialize with RR_prng('stochastic','xoroshiro128**') or RR_prng('deterministic','xoroshiro128**')
%
% INPUT: n = number of pseudorandom numbers to generate (OPTIONAL, n=1 by default)
% TEST:  RR_xoroshiro128ss(5)     % Generate 5 pseudorandom numbers
%
% Dependencies: https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/chap02/PRNGs/wrap_math
% Replace most calls to these functions, as appropriate, with simple * and + if converting
% to a language that can be set natively to wrap on integer overflow
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Efficient xoroshiro128** algorithm by Sebastiano Vigna available at https://prng.di.unimi.it/
%% Matlab implementation Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin<1, n=1; end   % number of pseudorandom numbers to generate
s=1; % Take just one stream (for now).  TODO: implement multiple streams.

global RR_PRNG_GENERATOR RR_PRNG_x
if ~strcmp(RR_PRNG_GENERATOR,'xoroshiro128**'), RR_prng('stochastic','xoroshiro128**'), end

% Prep to calculate using local values {s0,s1,s2,s3} [follow Vigna's notation]
s0=RR_PRNG_x(1,s); s1=RR_PRNG_x(2,s);

% Below is the RR implementation of the xoroshiro128** algorithm by Sebastiano Vigna:
% out=((s0*5)<<<7)*9;  s1=s1^s0;  s0=(s0<<<24)^s1^(s1<<16);  s1=(s1<<<37);
for i=1:n
  out(i)=RR_prod64s(RR_rotl64(RR_prod64s(s0,0x5u64),7),0x9u64); s1=bitxor(s1,s0);
  s0=bitxor(bitxor(RR_rotl64(s0,24),s1),bitsll(s1,16)); s1=RR_rotl64(s1,37); 
end

% Save current value of state for next time
RR_PRNG_x(1,s)=s0; RR_PRNG_x(2,s)=s1;
