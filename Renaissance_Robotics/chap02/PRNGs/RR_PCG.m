function out=RR_PCG(n,scheme,init)
% function out=RR_PCG(n,scheme,init)
% Wrapper for O'Neill's Permuted Congruential Generator schemes (with 32 or 64 bit output)
% with a (globally-defined and internally stored) state of 64 or 128 bits.
%
% INPUTS: n = number of pseudorandom numbers to generate (OPTIONAL, n=1 by default)
%         scheme = {'32','32_rev','64','64_rev'} selects the scheme (OPTIONAL, '32' by default)
%         init = 'stochastic' or 'deterministic' (OPTIONAL, uses 'stochastic', if necessary, by default)
% OUTPUT: out = a vector, of length n, with uint64 integers
% TEST:   RR_PCG(5,'32')      % Generate 5 uint32s using PCG32 (XSH RR variant)
%         RR_PCG(5,'32_rev')  % Back up, compute previous 5 uint32s using PCG32_rev
%         RR_PCG(5,'64')      % Generate 5 uint64s using PCG64 (DXSM variant)
%         RR_PCG(5,'64_rev')  % Back up, compute previous 5 uint64s using PCG64_rev
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin<1, n=1; end   % number of pseudorandom numbers to generate
if nargin<2, scheme='32'; end
s=1; % Take just one stream (for now).  TODO: implement multiple streams.

switch scheme
  case {'32','32_rev'}                      
     global RR_PRNG_2x64;
     if nargin==3 | isempty(RR_PRNG_2x64), if nargin<3, init='stochastic'; end
       RR_prng(64,init,2); % note: the second entry of RR_PRNG_2x64 is the (constant) c
     end  
  case {'64','64_rev'}                      
     global RR_PRNG_2x128;
     if nargin==3 | isempty(RR_PRNG_2x128), if nargin<3, init='stochastic'; end
       RR_prng(128,init,2); % note: the second entry of RR_PRNG_2x128 is the (constant) c
     end    
end
switch scheme
   case '32',     [out,RR_PRNG_2x64(1,s) ]=RR_PCG32    (n,RR_PRNG_2x64(1,s), RR_PRNG_2x64(2,s) );
   case '32_rev', [out,RR_PRNG_2x64(1,s) ]=RR_PCG32_rev(n,RR_PRNG_2x64(1,s), RR_PRNG_2x64(2,s) );
   case '64',     [out,RR_PRNG_2x128(1,s)]=RR_PCG64    (n,RR_PRNG_2x128(1,s),RR_PRNG_2x128(2,s));
   case '64_rev', [out,RR_PRNG_2x128(1,s)]=RR_PCG64_rev(n,RR_PRNG_2x128(1,s),RR_PRNG_2x128(2,s));
end
