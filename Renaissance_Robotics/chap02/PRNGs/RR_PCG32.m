function x=RR_PCG(stream,skip)
% function x=RR_PCG(stream,skip)
% PRNG using Melissa O'Neill's Permuted Congruential Generator PCG32, with 64 bit state and 32 bit output
% for each stream; zillions of independent streams are possible. NOTE: for code simplicity, multiple streams
% must be initialized in numerical order, but can be called in arbitrary order after that.
% Initialization is based on the number of microseconds since midnight on New Years Eve in 2023.
% INPUT: stream = which independent stream to pull random number from (OPTIONAL, stream=1 by default)
%        skip = the number of steps to skip forward or backward in stream (OPTIONAL, skip=0 by default)
% TEST:  RR_PCG(1), RR_PCG(1), RR_PCG(1)  % Begin stream 1
%        RR_PCG(2), RR_PCG(2), RR_PCG(2)  % Begin stream 2
%        RR_PCG(1), RR_PCG(1), RR_PCG(1)  % continue random sequence in stream 1
%        RR_PCG(1,-6)                     % skip backwards 6 steps in PCG stream 1
%        clear RR_PCG, for i=1:100, RR_PCG(i); end  % inspect the random initilization of 100 streams
%        % The following test recovers the 32bit output (in hex) of Round 1 of O'Neill's pcg32-demo code
%        clear RR_PCG; for i=1:6, dec2hex(RR_PCG(0)), end  
% DEPENDENCIES: This Matlab code depends, internally, on the RR_uint64 class defined by:
%   https://github.com/tbewley/RR/blob/main/Renaissance_Robotics/chapAA/classes/RR_uint64.m
% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Efficient PCG algorithm (in C and C++) due to Melissa O'Neill, available at
%%    https://www.pcg-random.org/download.html
%% Matlab translation (meant primarily for pedagogical purposes) by Thomas Bewley.


% TODO: implement skip!


persistent state inc % Matlab will hold these 2 RR_uint64 variables as "persistent" for each stream of RR_PCG
if nargin==0, stream=1, end, s=max(stream,1);  % note: stream=0 test case makes use of stream=1
if length(state)<s                             % INITIALIZATION OF {state,inc} FOR THIS STREAM
  if length(state)==0; state={}; inc={}; end
  if s>1 & length(state)<s-1, error('RR_PCG streams must be initialized sequentially'), end
  switch stream
    case 0, disp('Initializing some deterministic values of {state,inc}, for TEST PURPOSES ONLY')
      old_state=RR_uint64(0x185706B82C2E03F8); % Generates values identical to Round 1
      inc{1}   =RR_uint64(109);                % of O'Neill's pcg32-demo.c code
    case 1, % initialize stream 1 based on the number of microseconds since midnight on 31 Dec 2023
      old_state=RR_uint64(convertTo(datetime,'epochtime','Epoch','1-Jan-2024','TicksPerSecond',1e6));
      inc{1}   =RR_uint64(bin2dec(fliplr(dec2bin(old_state.v,50))))*0x372AAF131886F61A;
      old_state=old_state*0x2545F4914F6CDD1D; inc{1}.v =bitset(inc{1}.v,1);
      fprintf('Initializing PCG stream   1 with old_state=%20u and odd increment=%20u\n',old_state.v,inc{1}.v)
    otherwise % initialize inc and state of stream t>1 based on inc and current state of stream t-1
      % note: take a=dec2hex(uint64(a)) for a=3935559000370003845 and 2685821657736338717 from L’Ecuyer (1999) 
      old_state = state{s-1} *0x369DEA0F31A53F85+1; % initialize state{s} using state{s-1}
      inc{s}    =(inc{s-1}-1)*0x2545F4914F6CDD1D+1; % (subtracting/adding 1 keeps each inc{t} odd)
    fprintf('Initializing PCG stream %3d with old_state=%20u and odd increment=%20u\n',s,old_state.v,inc{s}.v)
  end
else 
  old_state=state{s};  % Continuing computation in stream t
end

% Update internal 64-bit state of LCG for this stream
state{s}=old_state*0x5851F42D4C957F2D+inc{s};
% Then, calculate a 32-bit PCG output using XSH RR method, performing PCG output bit permutations.
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
% -a     2's comp.   bitcmp(a)+1
