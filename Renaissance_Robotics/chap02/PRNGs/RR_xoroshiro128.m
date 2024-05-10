function out=RR_xoroshiro128(n,scheme,init)
% function out=RR_xoroshiro128(n,scheme,init)
% Wrapper for Blackman & Vigna's xoroshiro128 (xor/rotate/shift/rotate) schemes (**, ++, + variants)
% with a (globally-defined and internally stored) 2x64=128 bit state, RR_PRNG_2x64.
%
% INPUTS: n = number of pseudorandom numbers to generate (OPTIONAL, n=1 by default)
%         scheme ={'ss','pp','p','ss_rev','pp_rev','p_rev'} selects which scheme to use (OPTIONAL, 'ss' by default)
%         init = 'stochastic' or 'deterministic' (OPTIONAL, uses 'stochastic', if necessary, by default)
% OUTPUT: out = a vector, of length n, with 64-bit uint64 integers
% TEST:   RR_xoroshiro128(5,'ss')      % Generate 5 uint64s using xoroshiro128**
%         RR_xoroshiro128(5,'ss_rev')  % Back up, compute previous 5 uint64s using xoroshiro128**_rev
%         RR_xoroshiro128(5,'pp')      % Generate 5 uint64s using xoroshiro128++
%         RR_xoroshiro128(5,'pp_rev')  % Back up, compute previous 5 uint64s using xoroshiro128++_rev
%         RR_xoroshiro128(5,'p')       % Generate 5 uint64s using xoroshiro128+
%         RR_xoroshiro128(5,'p_rev')   % Back up, compute previous 5 uint64s using xoroshiro128+_rev
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin<1, n=1; end   % number of pseudorandom numbers to generate
s=1; % Take just one stream (for now).  TODO: implement multiple streams.

global RR_PRNG_2x64; 
if nargin==3 | isempty(RR_PRNG_2x64), if nargin<3, init='stochastic', end, RR_prng(64,init,2), end  

switch scheme
   case 'ss',     [out,RR_PRNG_2x64(1:2,s)]=RR_xoroshiro128ss    (n,RR_PRNG_2x64(1:2,s));
   case 'ss_rev', [out,RR_PRNG_2x64(1:2,s)]=RR_xoroshiro128ss_rev(n,RR_PRNG_2x64(1:2,s));
   case 'pp',     [out,RR_PRNG_2x64(1:2,s)]=RR_xoroshiro128pp    (n,RR_PRNG_2x64(1:2,s));
   case 'pp_rev', [out,RR_PRNG_2x64(1:2,s)]=RR_xoroshiro128pp_rev(n,RR_PRNG_2x64(1:2,s));
   case 'p',      [out,RR_PRNG_2x64(1:2,s)]=RR_xoroshiro128p     (n,RR_PRNG_2x64(1:2,s));
   case 'p_rev',  [out,RR_PRNG_2x64(1:2,s)]=RR_xoroshiro128p_rev (n,RR_PRNG_2x64(1:2,s));
end