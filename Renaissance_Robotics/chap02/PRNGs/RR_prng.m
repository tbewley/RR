function RR_prng(bits,init,num)
% function RR_prng(bits,init,num)
% Code used to initialize stream 1 of the state variables of the RR pseudorandom number generators.
% INPUT: bits = {32,64,128} (bits per integer of state; OPTIONAL, default=64)
%        init = {'stochastic','deterministic'} (OPTIONAL, default='stochastic')
%        num  = {1,2,3,4}   (number of integers of state in case of bits=64; OPTIONAL, default=4)
% OUTPUT: none (instead, appropriate global state variables are initialized)
% 
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

if nargin<1, bits=64; end, if nargin<2, init='stochastic'; end, if nargin<3, num=64; end, 

a64=0xf1357aea2e62a9c5;       % 64-bit LCG multiplier from L’Ecuyer (1999)
if strcmp(init,'stochastic')  % generate a 64-bit random seed based on system clock
  t=uint64(convertTo(datetime,'epochtime','Epoch','1-Jan-2024','TicksPerSecond',1e6))+1;
  seed64=RR_prod64(a64,t);
else
  seed64=0x185706B82C2E03F8;  % or use a deterministic seed (by O'Neill, for her PCG32 example)
end

switch bits
  case 128                                    % This is for the RR_PCG64 case
    global RR_PRNG_2x128;                     % Note that this case uses the RR_uint128 data type
    a128=RR_uint128(0x278F2419A4D3A5F7,0xC2280069635487FD); % 128-bit LCG mult from L’Ecuyer (1999)
    RR_PRNG_2x128=RR_uint128([]);
    RR_PRNG_2x128(1,1)=a128*RR_uint128(seed64);
    RR_PRNG_2x128(2,1)=a128*RR_PRNG_2x128(1,1);
  case 64,
    switch num
      case 2, global RR_PRNG_2x64;            % This is for the RR_PCG32, RR_MWC128, and RR_xoroshiro128 cases
        RR_PRNG_2x64=uint64([]);
        RR_PRNG_2x64(1,1)=seed64;
        if strcmp(seed,'stochastic')
           RR_PRNG_2x64(2,1)=RR_prod64(a64,seed64);
        else
           RR_PRNG_2x64(2,1)=uint64(109);     % Deterministic case (c by O'Neill, for PCG32 example)
        end
      case 3, global RR_PRNG_3x64;            % This is for the RR_MWC192 case
        RR_PRNG_3x64=uint64([]);
        RR_PRNG_3x64(1,1)=seed64;
        RR_PRNG_3x64(2,1)=RR_prod64(a64,seed64);
        RR_PRNG_3x64(3,1)=RR_prod64(a64,RR_PRNG_3x64(2,1));
      case 4, global RR_PRNG_4x64;            % This is for the RR_MWC256 and RR_xoshiro256 cases
        RR_PRNG_4x64=uint64([]);
        RR_PRNG_4x64(1,1)=seed64;
        RR_PRNG_4x64(2,1)=RR_prod64(a64,seed64);
        RR_PRNG_4x64(3,1)=RR_prod64(a64,RR_PRNG_4x64(2,1));
        RR_PRNG_4x64(4,1)=RR_prod64(a64,RR_PRNG_4x64(3,1));
    end
  case 32, global RR_PRNG_4x32;               % This is for the RR_xoshiro128 cases
    a32=0xe817fb2d;                           % 32-bit LCG multiplier from L’Ecuyer (1999)
    RR_PRNG_4x32=uint32([]);
    RR_PRNG_4x32(1,1)=uint32(bitsrl(seed64,32));
    RR_PRNG_4x32(2,1)=uint32(bitand(seed64,0xFFFFFFFFu64));
    RR_PRNG_4x32(3,1)=RR_prod32(a32,RR_PRNG_4x32(2,1));
    RR_PRNG_4x32(4,1)=RR_prod32(a32,RR_PRNG_4x32(3,1));
end
