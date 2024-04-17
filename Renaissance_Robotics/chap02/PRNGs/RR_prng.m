function RR_prng(seed,generator)
% function RR_prng(seed,generator)
% Initialize the pseudorandom number generator (PRNG) used by RR_rand, RR_randi, and RR_randn.
% INPUTS: seed = 'stochastic' or 'deterministic'
%         generator = string specifying the PRNG algorithm, from list below:
%
%   generator        output   state     description
%  --------------------------------------------------------------------------------------- 
%  'xoshiro256++'    64-bit  4x 64-bit  Vigna's xor/shift/rotate ++ PRNG
%  'xoshiro256**'    64-bit  4x 64-bit  Vigna's xor/shift/rotate ** PRNG
%  'xoroshiro128++'  32-bit  4x 32-bit  Vigna's xor/rotate/shift/rotate ++ PRNG
%  'xoroshiro128**'  32-bit  4x 32-bit  Vigna's xor/rotate/shift/rotate ** PRNG
%  'MWC128XXA32'     32-bit  4x 32-bit  Kaitchuck's 32-bit Multiply With Carry PRNG
%  'MWC256XXA64'     64-bit  4x 64-bit  Kaitchuck's 64-bit Multiply With Carry PRNG
%  'PCG32'           32-bit  64-bit     O'Neill's 32-bit Permuted Congruential Generator
%
% Both seed and generator are OPTIONAL arguments, and are taken as
% seed='stochastic' and generator='xoroshiro128pp' unless otherwise specified. 
%
% Dependencies: https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/chap02/PRNGs/wrap_math
% Replace most calls to these functions, as appropriate, with simple * and + if converting
% to a language that can be set natively to wrap on integer overflow
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

global RR_PRNG_GENERATOR RR_PRNG_OUTPUT RR_PRNG_x, clear RR_PRNG_x

if nargin<1, seed='stochastic'; end
if nargin<2, generator='xoshiro256++'; end, RR_PRNG_GENERATOR=generator;
if ~strcmp(seed,'stochastic') & ~strcmp(seed,'deterministic'),
   error('The seed must be selected as stochastic or deterministic.'), end

a64=0xf1357aea2e62a9c5; a32=0xe817fb2d;
if strcmp(seed,'stochastic')                 % Random seed (based on system clock)
  t=uint64(convertTo(datetime,'epochtime','Epoch','1-Jan-2024','TicksPerSecond',1e6))+1;
  seed64=RR_prod64(a64,t);
else
  seed64=0x185706B82C2E03F8;                 % Deterministic seed
end
seed32=uint32(bitand(seed64,0xFFFFFFFFu64)); % seed32 = lower 32 bits of seed64

switch generator
  case {'xoshiro256++','xoshiro256**','MWC256XXA64'}
    RR_PRNG_OUTPUT='64bit'; RR_PRNG_x(1,1)=seed64; RR_PRNG_x(2,1)=RR_prod64(a64,seed64);
    RR_PRNG_x(3,1)=RR_prod64(a64,RR_PRNG_x(2,1));  RR_PRNG_x(4,1)=RR_prod64(a64,RR_PRNG_x(3,1));
  case {'xoshiro128++','xoshiro128**'}
    RR_PRNG_OUTPUT='32bit'; RR_PRNG_x(1,1)=seed32; RR_PRNG_x(2,1)=RR_prod32(a32,seed32);
    RR_PRNG_x(3,1)=RR_prod64(a32,RR_PRNG_x(2,1));  RR_PRNG_x(4,1)=RR_prod32(a32,RR_PRNG_x(3,1));    
  case {'xoroshiro128++','xoroshiro128**','MWC128XXA32'}
    RR_PRNG_OUTPUT='64bit'; RR_PRNG_x(1,1)=seed64; RR_PRNG_x(2,1)=RR_prod32(a64,seed64);
  case 'PCG32'
    RR_PRNG_OUTPUT='32bit';    RR_PRNG_x=seed64;                global RR_PRNG_c
    if strcmp(seed,'shuffle'), RR_PRNG_c=RR_prod64(a64,seed64); RR_PRNG_c=bitset(RR_PRNG_c,1);
    else,                      RR_PRNG_c=uint64(109); end
  otherwise
    error('That generator is not implemented.')
end

fprintf('Initializing the RR PRNG with %s seed and %s generator.\n',seed,generator)
