function [D,R]=RR_div128(Q,M)
% function [D,R]=RR_div128(Q,M)                      
% This code performs full uint128 by uint128 division using the nonrestoring division algorithm;
% look at RR_div64 first for a more streamlined template, and RR_div8 to understand how it works.
% INPUTS:  {Q,M} are RR_uint128, with Q=dividend, M=divisor
% OUTPUTS: {D,R} are RR_uint128, with Q=D*M+R
% TEST:
%   clear, clc, Q=RR_uint128(RR_xoshiro256pp,RR_xoshiro256pp), M=RR_uint128(RR_xoshiro256pp)
%   [DH,DL,RH,RL]=RR_div128(QH,QL,MH,ML)
%   [PH,PL]=RR_prod128s(DH,DL,ML)    % Calculate Y=D*M+R in 2 steps, compare visually with Q
%   [YH,YL]=RR_sum128(PH,PL,RH,RL)       
%   fprintf('{YH,YL}={%d,%d}  <-- The values of Y and Q should match\n',YH,YL)
%   fprintf('{QH,QL}={%d,%d}\n',QH,QL)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

Mbar=-M; R=uint128(0);
if M>D,       R=D;   D=uint128(0); return  % skip this algorithm for the trivial cases 
elseif M>D-M, R=D-M; D=uint128(1); return
else
  for N=128:-1:1
    s=bitget(R,64); R=bitsll(R,1); R=bitset(R,1,bitget(D,64)); D=bitsll(D,1);  
    if s, R=R+M; else, R=R+Mbar; end
    if bitget(R,64), D=bitset(D,1,0); else, D=bitset(D,1,1); end
  end
  if bitget(R,64), R=R+M; end
end

% TODO:
% RR_randi (no arguments for 64 bit number)
% RR_uminus64, 32, 8
% RR_uint128 and RR_uint256 operations needed:
% instantiate (one argument: bottom part = 0, 2-4 arguments: 2-4 parts)
% RR_bitsll
% RR_bitsrl
