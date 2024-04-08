function out=RR_xoroshiro128pp(n)
% function out=RR_xoroshiro128pp(n)
% PRNG using Sebastiano Vigna's xoroshiro128++, with a 4x32=128 bit state and 32 bit output
% Initialize with RR_prng('stochastic','xoroshiro128++') or RR_prng('deterministic','xoroshiro128++')
% This Matlab implementation is meant primarily for pedagogical purposes, it is not fast.
%
% INPUT: n = number of pseudorandom numbers to generate (OPTIONAL, n=1 by default)
% TEST:  RR_xoroshiro128pp(5)     % Generate 5 pseudorandom numbers
%
% Dependencies: https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/chap02/PRNGs/wrap_math
% Replace most calls to these functions, as appropriate, with simple * and + if converting
% to a language that can be set natively to wrap on integer overflow
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Efficient xoroshiro128++ algorithm by Sebastiano Vigna available at https://prng.di.unimi.it/
%% Matlab implementation Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin<1, n=1; end   % number of pseudorandom numbers to generate
s=1; % Take just one stream (for now).  TODO: implement multiple streams.

global RR_PRNG_GENERATOR RR_PRNG_x
if ~strcmp(RR_PRNG_GENERATOR,'xoroshiro128++'), RR_prng('stochastic','xoroshiro128++'), end

% Prep to calculate using local values {s0,s1} [follow Vigna's notation]
s0=RR_PRNG_x(1,s); s1=RR_PRNG_x(2,s);

% Below is the RR implementation of Vigna's xoroshiro128++ algorithm
for i=1:n
  out(i)=RR_sum64(RR_rotl64(RR_sum64(s0,s1),17),s0);    s1=bitxor(s1,s0);    % two additions
  s0=bitxor(bitxor(RR_rotl64(s0,49),s1),bitsll(s1,21)); s1=RR_rotl64(s1,28); % three XORs
end

% Save current value of state for next time
RR_PRNG_x(1,s)=s0; RR_PRNG_x(2,s)=s1;
