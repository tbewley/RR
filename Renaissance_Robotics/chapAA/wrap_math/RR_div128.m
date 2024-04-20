function [DH,DL,RH,RL]=RR_div128(QH,QL,MH,ML)
% function [DH,DL,RH,RL]=RR_div128(QH,QL,MH,ML)                      
% This code performs full uint128 by uint128 division using the nonrestoring division algorithm;
% look at RR_div64 first for a more streamlined template, and RR_div8 to understand how it works.
% INPUTS:  {QH,QL,MH,ML} are uint64, with  Q={QH,QL}=dividend, M={MH,ML}=divisor
% OUTPUTS: {DH,DL,RH,RL} are uint64, where D={DH,DL} and R={RH,RL} with Q=D*M+R
% TEST:
%   clear, clc, QH=RR_xoshiro256pp, QL=RR_xoshiro256pp, MH=uint64(0), ML=RR_xoshiro256pp
%   [DH,DL,RH,RL]=RR_div128(QH,QL,MH,ML)
%   [PH,PL]=RR_prod128s(DH,DL,ML)    % Calculate Y=D*M+R in 2 steps, compare visually with Q
%   [YH,YL]=RR_sum128(PH,PL,RH,RL)       
%   fprintf('{YH,YL}={%d,%d}  <-- The values of Y and Q should match\n',YH,YL)
%   fprintf('{QH,QL}={%d,%d}\n',QH,QL)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

DH=uint64(QH); DH=uint64(QH); MH=uint64(MH); ML=uint64(ML);
MbarH,MbarL=RR_minus(MH,ML);  RH=uint64(0);  RL=RH;
if M>Q,       DH=RH; DL=DH; RH=QH; RL=QL; return  % skip this algorithm for the trivial cases 
elseif M>Q-M, DH=RH; DL=uint64(1); R=Q-M; return
else
  for N=Nmax:-1:1
    s=bitget(R,Nmax); R=bitsll(R,1); R=bitset(R,1,bitget(D,Nmax)); D=bitsll(D,1);  
    if s, R=RR_sum64(R,M); else, R=RR_sum64(R,Mbar); end
    if bitget(R,Nmax), D=bitset(D,1,0); else, D=bitset(D,1,1); end
  end
  if bitget(R,Nmax), R=RR_sum64(R,M); end
end

% RR_randi (no arguments for 64 bit number)
% RR_uminus64, 32, 8
% RR_uint128 and RR_uint256 operations needed:
% instantiate (one argument: bottom part = 0, 2-4 arguments: 2-4 parts)
% unary_minus
% sum
% product
% RR_bitsll
% RR_bitsrl
