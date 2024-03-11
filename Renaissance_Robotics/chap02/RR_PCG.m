function x=RR_PCG(thread)
% PRNG using Melissa O'Neill's Permuted Congruential Generator (PCG), with 64 bit state and 32 bit output
% for each thread; many many independent threads are possible. NOTE: for code simplicity, multiple threads
% must be initialized in numerical order, but can be called in arbitrary order after that.
% INPUT: thread = which independent thread to pull random number from (optional, thread=1 by default)
% TEST:  RR_PCG(1), RR_PCG(1), RR_PCG(1)  % Begin thread=1
%        RR_PCG(2), RR_PCG(2), RR_PCG(2)  % Begin thread=2
%        RR_PCG(1), RR_PCG(1), RR_PCG(1)  % continue random sequence in thread=1
%        clear RR_PCG, for i=1:100, RR_PCG(i); end  % inspect the random initilization of 100 threads
%        % The following test recovers the 32bit output (in hex) of Round 1 of O'Neill's pcg32-demo code
%        clear RR_PCG; for i=1:6, dec2hex(RR_PCG(0)), end  
% DEPENDENCIES: This Matlab code uses the RR_uint64 class defined by the code at:
%   https://github.com/tbewley/RR/blob/main/chapAA/RR_uint64.m
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Efficient PCG algorithm (in C and C++) due to Melissa O'Neill, available at
%%    https://www.pcg-random.org/download.html
%% Matlab translation (meant primarily for pedagogical purposes) by Thomas Bewley.

persistent state inc % Matlab will hold these variables as "persistent" for this function
if nargin==0, thread=1, end, t=max(thread,1);  % note: thread=0 test case makes use of thread=1
if length(state)==0; state={}; inc={}; end
if length(state)<t                                % INITIALIZATION OF {state,inc}
  if t>1 & length(state)<t-1, error('RR_PCG threads must be initialized sequentially'), end
  switch thread
    case 0, disp('Initializing some deterministic values of {state,inc}, for TEST PURPOSES ONLY')
      old_state=RR_uint64(0x185706B82C2E03F8); % Generates values identical to Round 1
      inc{1}   =RR_uint64(109);                % of O'Neill's pcg32-demo.c code
    case 1, % initialize {state,inc} based on milliseconds since most recent New Years Day (NYD)
      NYD      =strcat('1-Jan-',num2str(year(datetime))); 
      old_state=RR_uint64(convertTo(datetime,'epochtime','Epoch',NYD,'TicksPerSecond',1e6))*0x2545F4914F6CDD1D;
      inc{1}   =RR_uint64(bin2dec(fliplr(dec2bin(old_state.v,50))))*0x372AAF131886F61A;
      inc{1}.v =bitset(inc{1}.v,1);
      fprintf('Initializing PCG thread   1 with old_state=%20u and odd increment=%20u\n',old_state.v,inc{1}.v)
    otherwise
      % note: take a=dec2hex(uint64(a)) for a=3935559000370003845 and 2685821657736338717 from L’Ecuyer (1999) 
      old_state = state{t-1} *0x369DEA0F31A53F85+1; % initialize state{t} using state{t-1}
      inc{t}    =(inc{t-1}-1)*0x2545F4914F6CDD1D+1; % (subtracting/adding 1 keeps each inc{t} odd)
    fprintf('Initializing PCG thread %3d with old_state=%20u and odd increment=%20u\n',t,old_state.v,inc{t}.v)
  end
else 
  old_state=state{t};  % Continuing computation in thread t
end

% Update internal 64-bit state of PCG for this thread
state{t}=old_state*0x5851F42D4C957F2D+inc{t};
state{t}
% Then, calculate a 32-bit output using XSH RR method, performing PCG output bit permutations.
% See section 6.3.1 of https://www.pcg-random.org/pdf/hmc-cs-2014-0905.pdf 
x   = uint32(bitand(bitsra(bitxor(bitsra(old_state.v,18),old_state.v),27),0x00000000FFFFFFFF));
rot = uint32(bitsra(old_state.v,59));
x   = bitor(bitsra(x,rot),bitsll(x,(bitand(bitcmp(rot)+1,31))));

% For comparison to O'Neill's PCG, here are some bitwise operations on integers, in both C and Matlab:
%  C  Bit Operations   Matlab
% ------------------------------
% a>>k  rightshift   bitsra(a,k)
% a<<k  leftshift    bitsll(a,k)
% a&b      AND       bitand(a,b)
% a^b      XOR       bitxor(a,b)
% a|b      OR        bitor(a,b)
% -a     2's comp.   bitcmp(a
