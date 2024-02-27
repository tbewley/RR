function x=RR_PCG_minimal(thread)
% Minimal PRNG with a Permuted Congruential Generator (PCG), with 64 bit state, 32 bit output.
% 
% Note: if this routine hasn't been run yet in this Matlab session, it
% initializes the previous state using the state of the clock.
%% Renaissance Robotics codebase, Chapter 2, https://github.com/tbewley/RR
%% Efficient PCG algorithm (in C and C++) due to Melissa O'Neill, available at
%%    https://www.pcg-random.org/download.html
%% INEFFICIENT Matlab translation (meant for pedagogical purposes only) by Thomas Bewley.

persistent state inc a  % Matlab will hold these variables as "persistent" for this function
if nargin==0, thread=1, end
if length(state)==0; state={}, inc={}, end
if length(state)<max(thread,1)           % INITIALIZATION OF {state,inc}
  if thread==0                           % Initialize deterministically, to values
    old   =RR_uint64(0x185706B82C2E03F8) % consistent with O'Neill's demo code
    inc{1}=RR_uint64(109)                % note: inc must be odd.
  else                                   % Initialize state randomly based on the clock
    old=RR_uint64(convertTo(datetime,'epochtime','Epoch','1-Jan-2024','TicksPerSecond',1e6));
    inc{thread}=RR_uint64(2*thread-1);   % Initialize inc as a convenient odd integer
  end
else
  old=state{thread};
end
thread=max(thread,1);

state{thread}=old*0x5851F42D4C957F2D+inc{thread};
% Then, calculate 32 bit output using XSH RR method, performing PCG output bit permutations.
xorshifted = uint32( bitsra(bitxor(bitsra(old.v,18),old.v),27) );
rot = uint32(bitsra(old.v,59))
x   = bitor(bitsra(xorshifted,rot),bitsll(xorshifted,(bitand(-rot,31))));


% cheatsheet: bitwise operations on integers, in both C and Matlab
%  C  Bit Operations   Matlab
% ------------------------------
% a>>k  rightshift   bitsra(a,k)
% a<<k  leftshift    bitsll(a,k)
% a&b      AND       bitand(a,b)
% a^b      XOR       bitxor(a,b)
% a|b      OR        bitor(a,b)
% -a     2's comp.   bitcmp(a)