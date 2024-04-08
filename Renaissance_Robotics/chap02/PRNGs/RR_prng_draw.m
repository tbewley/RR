function X=RR_prng_draw(n)
% function X=RR_prng_draw(n)
% Draw n pseudorandom numbers from stream 1 of one of the (several) implemented generators,
% as initialized by RR_prng.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

global RR_PRNG_GENERATOR
switch RR_PRNG_GENERATOR
  case 'xoshiro256++',   X=RR_xoshiro256pp(n);
  case 'xoshiro256**',   X=RR_xoshiro256ss(n);
  case 'xoroshiro128++', X=RR_xoroshiro128pp(n);
  case 'xoroshiro128**', X=RR_xoroshiro128ss(n);
  case 'MWC256XXA64',    X=RR_MWC256XXA64(n);
  case 'MWC128XXA32',    X=RR_MWC128XXA32(n);
  case 'PCG32',          X=RR_PCG32(n);
  otherwise,             error('That generator is not implemented.')
end
