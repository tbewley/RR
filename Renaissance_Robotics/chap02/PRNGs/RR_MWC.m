function out=RR_MWC(n,scheme,init)
% function out=RR_MWC(n,scheme,init)
% Wrapper for Vigna's tuning of Marsaglia's Multiply With Carry (MWC) schemes (128, 192, and 256 bit variants)
% with a (globally-defined and internally stored) state of 2x64=128, 3x64=192, or 4x64=256 bits.
%
% INPUTS: n = number of pseudorandom numbers to generate (OPTIONAL, n=1 by default)
%         scheme = {'128','192','256','128_rev','192_rev','256_rev'} selects the scheme (OPTIONAL, '256' by default)
%         init = 'stochastic' or 'deterministic' (OPTIONAL, uses 'stochastic', if necessary, by default)
% OUTPUT: out = a vector, of length n, with uint64 integers
% TEST:   RR_MWC(5,'128')      % Generate 5 uint64s using MWC128
%         RR_MWC(5,'128_rev')  % Back up, compute previous 5 uint64s using MWC128_rev
%         RR_MWC(5,'192')      % Generate 5 uint64s using MWC192
%         RR_MWC(5,'192_rev')  % Back up, compute previous 5 uint64s using MWC192_rev
%         RR_MWC(5,'256')      % Generate 5 uint64s using MWC256
%         RR_MWC(5,'256_rev')  % Back up, compute previous 5 uint64s using MWC256_rev
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin<1, n=1; end   % number of pseudorandom numbers to generate
if nargin<2, scheme='256'; end
s=1; % Take just one stream (for now).  TODO: implement multiple streams.

switch scheme
  case {'128','128_rev'}                      
     global RR_PRNG_2x64;
     if nargin==3 | isempty(RR_PRNG_2x64), if nargin<3, init='stochastic', end
       RR_prng(64,init,2); RR_PRNG_2x64(2,s)=bitset(RR_PRNG_2x64(2,s),64,0);
     end  
  case {'192','192_rev'}                      
     global RR_PRNG_3x64;
     if nargin==3 | isempty(RR_PRNG_3x64), if nargin<3, init='stochastic', end
       RR_prng(64,init,3); RR_PRNG_3x64(3,s)=bitset(RR_PRNG_3x64(3,s),64,0);
     end  
  case {'256','256_rev'}                      
     global RR_PRNG_4x64;
     if nargin==3 | isempty(RR_PRNG_4x64), if nargin<3, init='stochastic', end
       RR_prng(64,init,4); RR_PRNG_4x64(4,s)=bitset(RR_PRNG_4x64(4,s),64,0);
     end  
end
switch scheme
   case '128',     [out,RR_PRNG_2x64(1:2,s)]=RR_MWC128    (n,RR_PRNG_2x64(1:2,s));
   case '128_rev', [out,RR_PRNG_2x64(1:2,s)]=RR_MWC128_rev(n,RR_PRNG_2x64(1:2,s));
   case '192',     [out,RR_PRNG_3x64(1:3,s)]=RR_MWC192    (n,RR_PRNG_3x64(1:3,s));
   case '192_rev', [out,RR_PRNG_3x64(1:3,s)]=RR_MWC192_rev(n,RR_PRNG_3x64(1:3,s));
   case '256',     [out,RR_PRNG_4x64(1:4,s)]=RR_MWC256    (n,RR_PRNG_4x64(1:4,s));
   case '256_rev', [out,RR_PRNG_4x64(1:4,s)]=RR_MWC256_rev(n,RR_PRNG_4x64(1:4,s));
end