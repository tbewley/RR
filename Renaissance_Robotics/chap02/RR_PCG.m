function x=RR_PCG(thread)
% PRNG using Melissa O'Neill's Permuted Congruential Generator (PCG), with 64 bit state and 32 bit output
% for each thread; many many independent threads are possible.  For code simplicity, multiple threads
% must be initialized in numerical order, but can be called in arbitrary order after that.
% INPUT: thread = which independent thread to pull random number from (optional, thread=1 by default)
% TEST:  RR_PCG_minimal(1), RR_PCG_minimal(1), RR_PCG_minimal(1)  % Begin thread=1
%        RR_PCG_minimal(2), RR_PCG_minimal(2), RR_PCG_minimal(2)  % Begin thread=2
%        RR_PCG_minimal(1), RR_PCG_minimal(1), RR_PCG_minimal(1)  % continue random sequence in thread=1
%        % The following test recovers the 32bit output (in hex) of Round 1 of O'Neill's pcg32-demo code
%        clear RR_PCG_minimal; for i=1:6, dec2hex(RR_PCG_minimal(0)), end  
% Note: if this routine, for this thread, hasn't been run yet in this Matlab session,
% it initializes the state using the time/date.
% DEPENDENCIES: This Matlab code uses the RR_uint64 class defined by the code at:
%   https://github.com/tbewley/RR/blob/main/chapAA/RR_uint64.m
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/RR_chap02
%% Efficient PCG algorithm (in C and C++) due to Melissa O'Neill, available at
%%    https://www.pcg-random.org/download.html
%% Matlab translation (meant for pedagogical purposes only) by Thomas Bewley.

persistent state inc  % Matlab will hold these variables as "persistent" for this function
if nargin==0, thread=1, end, t=max(thread,1);  % note: thread=0 test case makes use of thread=1
if length(state)==0; state={}; inc={}; end
if length(state)<t                           % INITIALIZATION OF {state,inc}
  if thread==0                               % Test case: Initialize state deterministically
  	disp('Initializing some deterministic values of {state,inc}, for TEST PURPOSES ONLY')
    old_state=RR_uint64(0x185706B82C2E03F8); % Generates values identical to Round 1 of pcg32-demo.c code
    inc{1}=RR_uint64(109);                   
  else                                       % Other cases: Initialize state randomly based on the clock
    fprintf('Initializing a random value of oldstate, increment for thread=%d\n',t)
    date=convertTo(datetime,'epochtime','Epoch','1-Jan-2024','TicksPerSecond',1e6);
    old_state=RR_uint64(bin2dec(fliplr(dec2bin(date,50))))
    % Initialize increment as convenient odd integer
    if thread==1; inc{t}=RR_uint64(date); bitset(date,1); % Note inc must be odd.
    % note a=dec2hex(uint64(1987591058829310733)*2), taking 2*a, c=0 (m=2^63) generator from L’Ecuyer (1999) 
    else, inc{t}=(inc{t-1}-1)*0x372AAF131886F61A+1; end   % and adding 1 to keep each value of inc odd.
    inc{t}=increment;
  end
else 
  old_state=state{t};  % Continuing computation in thread t
end

% Update internal 64-bit state for this thread
state{t}=old_state*0x5851F42D4C957F2D+inc{t};
% Then, calculate a 32-bit output using XSH RR method, performing PCG output bit permutations.
% See section 6.3.1 of https://www.pcg-random.org/pdf/hmc-cs-2014-0905.pdf 
x   = uint32(bitand(bitsra(bitxor(bitsra(old_state.v,18),old_state.v),27),0x00000000FFFFFFFF));
rot = uint32(bitsra(old_state.v,59));
x   = bitor(bitsra(x,rot),bitsll(x,(bitand(bitcmp(rot)+1,31))));

% For comparison to O'Neill's PCG, here are some bitwise operations on integers, in both C and Matlab
%  C  Bit Operations   Matlab
% ------------------------------
% a>>k  rightshift   bitsra(a,k)
% a<<k  leftshift    bitsll(a,k)
% a&b      AND       bitand(a,b)
% a^b      XOR       bitxor(a,b)
% a|b      OR        bitor(a,b)
% -a     2's comp.   bitcmp(a
