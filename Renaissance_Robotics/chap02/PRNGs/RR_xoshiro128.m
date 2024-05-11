function out=RR_xoshiro128(n,scheme,init)
% function out=RR_xoshiro128(n,scheme,init)
% Wrapper for Blackman & Vigna's xoshiro128 (xor/shift/rotate) schemes (**, ++, + variants)
% with a (globally-defined and internally stored) 4x32=128 bit state, RR_PRNG_4x32.
%
% INPUTS: n = number of pseudorandom numbers to generate (OPTIONAL, n=1 by default)
%         scheme ={'ss','pp','p','ss_rev','pp_rev','p_rev'} selects which scheme to use (OPTIONAL, 'ss' by default)
%         init = 'stochastic' or 'deterministic' (OPTIONAL, uses 'stochastic', if necessary, by default)
% OUTPUT: out = a vector, of length n, with uint32 integers
% TEST:   RR_xoshiro128(5,'ss')      % Generate 5 uint32s using xoshiro128**
%         RR_xoshiro128(5,'ss_rev')  % Back up, compute previous 5 uint32s using xoshiro128**_rev
%         RR_xoshiro128(5,'pp')      % Generate 5 uint32s using xoshiro128++
%         RR_xoshiro128(5,'pp_rev')  % Back up, compute previous 5 uint32s using xoshiro128++_rev
%         RR_xoshiro128(5,'p')       % Generate 5 uint32s using xoshiro128+
%         RR_xoshiro128(5,'p_rev')   % Back up, compute previous 5 uint32s using xoshiro128+_rev
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin<1, n=1; end   % number of pseudorandom numbers to generate
s=1; % Take just one stream (for now).  TODO: implement multiple streams.

global RR_PRNG_4x32; 
if nargin==3 | isempty(RR_PRNG_4x32), if nargin<3, init='stochastic', end, RR_prng(32,init,4), end  

switch scheme
   case 'ss',     [out,RR_PRNG_4x32(1:4,s)]=RR_xoshiro128ss    (n,RR_PRNG_4x32(1:4,s));
   case 'ss_rev', [out,RR_PRNG_4x32(1:4,s)]=RR_xoshiro128ss_rev(n,RR_PRNG_4x32(1:4,s));
   case 'pp',     [out,RR_PRNG_4x32(1:4,s)]=RR_xoshiro128pp    (n,RR_PRNG_4x32(1:4,s));
   case 'pp_rev', [out,RR_PRNG_4x32(1:4,s)]=RR_xoshiro128pp_rev(n,RR_PRNG_4x32(1:4,s));
   case 'p',      [out,RR_PRNG_4x32(1:4,s)]=RR_xoshiro128p     (n,RR_PRNG_4x32(1:4,s));
   case 'p_rev',  [out,RR_PRNG_4x32(1:4,s)]=RR_xoshiro128p_rev (n,RR_PRNG_4x32(1:4,s));
end