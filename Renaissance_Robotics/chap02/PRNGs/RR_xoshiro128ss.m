function out=RR_xoshiro128ss(n)
% function out=RR_xoshiro128ss(n)
% PRNG using Sebastiano Vigna's xoshiro128**, with a 4x32=128 bit state and 32 bit output
% Initialize with RR_prng('stochastic','xoshiro128**') or RR_prng('deterministic','xoshiro128**')
%
% INPUT: n = number of pseudorandom numbers to generate (OPTIONAL, n=1 by default)
% TEST:  RR_xoshiro128ss(5)     % Generate 5 pseudorandom numbers
%
% Dependencies: https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/chap02/PRNGs/wrap_math
% Replace most calls to these functions, as appropriate, with simple * and + if converting
% to a language that can be set natively to wrap on integer overflow
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Efficient xoshiro256** algorithm by Sebastiano Vigna available at https://prng.di.unimi.it/
%% Matlab implementation Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin<1, n=1; end   % number of pseudorandom numbers to generate
s=1; % Take just one stream (for now).  TODO: implement multiple streams.

global RR_PRNG_GENERATOR RR_PRNG_x
if ~strcmp(RR_PRNG_GENERATOR,'xoshiro128**'), RR_prng('stochastic','xoshiro128**'), end

% Prep to calculate using local values {s0,s1,s2,s3} [follow Vigna's notation]
s0=RR_PRNG_x(1,s); s1=RR_PRNG_x(2,s); s2=RR_PRNG_x(3,s); s3=RR_PRNG_x(4,s);

% Below is the RR implementation of the xoshiro128** algorithm by Sebastiano Vigna
for i=1:n
  out(i)=RR_prod32(RR_rotl32(RR_prod32(s1,0x5u32),7),0x9u32); % two multiplications
  t=bitsll(s1,9); s2=bitxor(s2,s0); s3=bitxor(s3,s1); s1=bitxor(s1,s2);  % five XORs
                  s0=bitxor(s0,s3); s2=bitxor(s2,t ); s3=RR_rotl32(s3,11);
end

disp('THERE IS STILL A BUG IN THIS ONE.')

% Save current value of state for next time
RR_PRNG_x(1,s)=s0; RR_PRNG_x(2,s)=s1; RR_PRNG_x(3,s)=s2; RR_PRNG_x(4,s)=s3;
