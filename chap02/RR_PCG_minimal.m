function x=RR_PCG_minimal
% PRNG with a Permuted Congruential Generator (PCG) with period m-1 where m=2^64
% Note: if this routine hasn't been run yet in this Matlab session, it
% initializes the previous state using the state of the clock.
%% Renaissance Robotics codebase, Chapter 2, https://github.com/tbewley/RR
%% Minimal PCG algorithm due to Melissa O'Neill, available at
%%    https://www.pcg-random.org/download.html
%% Matlab translation (tried to keep a similar notation...) by Thomas Bewley.
%% This code is for pedagogical purposes only, it is grossly inefficient.
%% Use O'Neill's C and C++ codes for any practical application.

persistent state inc a  % Matlab will hold these "persistent" variables for this function
if isempty(state)       % Initialize state and inc as some big integers, with inc odd 
  inc  =uint64(convertTo(datetime,'epochtime','Epoch','1-Jan-2000','TicksPerSecond',1e6));
  state=uint64(inc*(pi*100)), inc=inc+uint64(~bitget(inc,1))
  a    =uint64(6364136223846793005);  % initialize multiplier
end
oldstate=state           % use oldstate below to improve instruction-level parallelism
state=a*oldstate + inc;  % Advance internal state

% Calculate the output x (XSH RR).  Herein lies the PCG output bit permutation magic.
xorshifted = uint32( bitsra(bitxor(bitsra(oldstate,18),oldstate),27) );
rot = uint32(bitsra(oldstate,59))
x   = bitor(bitsra(xorshifted,rot),bitsll(xorshifted,(bitand(-rot,31))));

% cheatsheet: bitwise operations on integers, in both C and Matlab
%  C  Bit Operations   Matlab
% ------------------------------
% a>>k  rightshift   bitsra(a,k)
% a<<k  leftshift    bitsll(a,k)
% a&b      AND       bitand(a,b)
% a^b      XOR       bitxor(a,b)
% a|b      OR        bitor(a,b)
% -  ?      

