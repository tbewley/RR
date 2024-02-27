function x=RR_PCG_minimal(thread)
% PRNG using a Permuted Congruential Generator (PCG), with 64 bit state and 32 bit output
% for each thread; a large number (n < 2^63) of independent random threads is possible.
% TEST:  RR_PCG_minimal(1), RR_PCG_minimal(1), RR_PCG_minimal(1)  % Begin thread=1
%        RR_PCG_minimal(2), RR_PCG_minimal(2),                    % Begin thread=2
%        RR_PCG_minimal(1), RR_PCG_minimal(1),                    % continue random sequence in thread=1
%        clear RR_PCG_minimal                                     % Reset internal state variables
%        RR_PCG_minimal(0), RR_PCG_minimal(0), RR_PCG_minimal(0)  % demo sequence by O'Neill
% Note: if this routine, for this thread, hasn't been run yet in this Matlab session,
% it initializes the state using the time/date.
%% Renaissance Robotics codebase, Chapter 2, https://github.com/tbewley/RR
%% Efficient PCG algorithm (in C and C++) due to Melissa O'Neill, available at
%%    https://www.pcg-random.org/download.html
%% Inefficient Matlab translation (meant for pedagogical purposes only) by Thomas Bewley.

persistent state inc  % Matlab will hold these variables as "persistent" for this function
if nargin==0, thread=1, end, t=max(thread,1);  % note: test case makes use of thread=1
if length(state)==0; state={}; inc={}; end
if length(state)<t                        % INITIALIZATION OF {state,inc}
  if thread==0                            % Test case: Initialize state deterministically
  	disp('Initializing deterministic values of {state,inc}, for TEST PURPOSES ONLY')
    old_state=RR_uint64(0x185706B82C2E03F8); % use values consistent with O'Neill's demo code
    inc{1}=RR_uint64(109);                   % note: inc must be odd.
  else                                    % Other cases: Initialize state randomly, based on the clock
    date=convertTo(datetime,'epochtime','Epoch','1-Jan-2024','TicksPerSecond',1e6)
    old_state=RR_uint64(bin2dec(fliplr(dec2bin(date,50))));  % Note necessary, but fun
    increment=2*t-1;                      % Initialize inc as a convenient odd integer
  	fprintf('Initializing a random value of state, thread=%d, inc=%d\n',t,increment)
  	inc{t}=RR_uint64(increment);
  end
else
  fprintf('Continuing computation in thread=%d\n',thread)
  old_state=state{t}
end

% Update internal 64-bit state for this thread
new_state=old_state*0x5851F42D4C957F2D+inc{t},  state{t}=new_state;
% Then, calculate a 32-bit output using XSH RR method, performing PCG output bit permutations.
xorshifted = uint32( bitsra(bitxor(bitsra(old_state.v,18),old_state.v),27) );
rot = uint32(bitsra(old_state.v,59));
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