function out=RR_xoshiro256(n,scheme,init)
% function out=RR_xoshiro256(n,scheme,init)
% Wrapper for Blackman & Vigna's xoshiro256 (xor/shift/rotate) schemes (**, ++, + variants)
% with a (globally-defined and internally stored) 4x64=256 bit state, RR_PRNG_4x64.
%
% INPUTS: n = number of pseudorandom numbers to generate (OPTIONAL, n=1 by default)
%         scheme = {'ss','ss_rev','pp','pp_rev','p','p_rev'} selects the scheme (OPTIONAL, 'ss' by default)
%         init = 'stochastic' or 'deterministic' (OPTIONAL, uses 'stochastic', if necessary, by default)
% OUTPUT: out = a vector, of length n, with uint64 integers
% TEST:   RR_xoshiro256(5,'ss')      % Generate 5 uint64s using xoshiro256**
%         RR_xoshiro256(5,'ss_rev')  % Back up, compute previous 5 uint64s using xoshiro256**_rev
%         RR_xoshiro256(5,'pp')      % Generate 5 uint64s using xoshiro256++
%         RR_xoshiro256(5,'pp_rev')  % Back up, compute previous 5 uint64s using xoshiro256++_rev
%         RR_xoshiro256(5,'p')       % Generate 5 uint64s using xoshiro256+
%         RR_xoshiro256(5,'p_rev')   % Back up, compute previous 5 uint64s using xoshiro256+_rev
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin<1, n=1; end   % number of pseudorandom numbers to generate
if nargin<2, scheme='ss'; end
s=1; % Take just one stream (for now).  TODO: implement multiple streams.

global RR_PRNG_4x64; 
if nargin==3 | isempty(RR_PRNG_4x64), if nargin<3, init='stochastic'; end, RR_prng(64,init,4), end  

switch scheme
   case 'ss',     [out,RR_PRNG_4x64(1:4,s)]=RR_xoshiro256ss    (n,RR_PRNG_4x64(1:4,s));
   case 'ss_rev', [out,RR_PRNG_4x64(1:4,s)]=RR_xoshiro256ss_rev(n,RR_PRNG_4x64(1:4,s));
   case 'pp',     [out,RR_PRNG_4x64(1:4,s)]=RR_xoshiro256pp    (n,RR_PRNG_4x64(1:4,s));
   case 'pp_rev', [out,RR_PRNG_4x64(1:4,s)]=RR_xoshiro256pp_rev(n,RR_PRNG_4x64(1:4,s));
   case 'p',      [out,RR_PRNG_4x64(1:4,s)]=RR_xoshiro256p     (n,RR_PRNG_4x64(1:4,s));
   case 'p_rev',  [out,RR_PRNG_4x64(1:4,s)]=RR_xoshiro256p_rev (n,RR_PRNG_4x64(1:4,s));
end