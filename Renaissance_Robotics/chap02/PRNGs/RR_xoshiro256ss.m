function out=RR_xoshiro256ss(n)
% function out=RR_xoshiro256ss(n)
% PRNG using Sebastiano Vigna's xoshiro256**, with a 4x64=256 bit state and 64 bit output
% Initialize with RR_prng('stochastic','xoshiro256**') or RR_prng('deterministic','xoshiro256**')
%
% INPUT: n = number of pseudorandom numbers to generate (OPTIONAL, n=1 by default)
% TEST:  RR_xoshiro256ss(5)     % Generate 5 pseudorandom numbers
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
if ~strcmp(RR_PRNG_GENERATOR,'xoshiro256**'), RR_prng('stochastic','xoshiro256**'), end

% Prep to calculate using local values {s0,s1,s2,s3} [follow Vigna's notation]
s0=RR_PRNG_x(1,s); s1=RR_PRNG_x(2,s); s2=RR_PRNG_x(3,s); s3=RR_PRNG_x(4,s);

% Below is the RR implementation of the xoshiro256** algorithm by Sebastiano Vigna
for i=1:n
  out(i)=RR_prod64s(RR_rotl64(RR_prod64s(s1,0x5u64),7),0x9u64); % two multiplications
  t=bitsll(s1,17); s2=bitxor(s2,s0); s3=bitxor(s3,s1); s1=bitxor(s1,s2);  % five XORs
                   s0=bitxor(s0,s3); s2=bitxor(s2,t ); s3=RR_rotl64(s3,45);
end

% Save current value of state for next time
RR_PRNG_x(1,s)=s0; RR_PRNG_x(2,s)=s1; RR_PRNG_x(3,s)=s2; RR_PRNG_x(4,s)=s3;
