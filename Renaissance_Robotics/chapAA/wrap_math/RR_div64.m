function [D,R]=RR_div64(Q,M)
% function [D,R]=RR_div64(Q,M)          
% This code performs full uint64  by uint64  division using the nonrestoring division algorithm,
% and forms a streamlined template for RR_div128 and RR_div256.
% INPUTS:  Q, M are each uint64 (or uint8,uint16,uint32,single,double) Q=dividend, M=divisor
% OUTPUTS: D and R are uint64, with Q=D*M+R
% TEST:
%   clear, clc, Q=RR_xoshiro256pp, M=bitsra(RR_xoshiro256pp,3)
%   [D,R]=RR_div64(Q,M), fprintf('Check: D*M+R-Q = %d, which should be zero\n',D*M+R-Q)
%   fprintf('       M-R = %6.6e, which should be positive\n',double(M)-double(R))         
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

D=uint64(Q);  M=uint64(M); Mbar=bitcmp(M)+1; R=uint64(0);
if M>D,       R=D;   D=uint64(0); return  % skip algorithm below for the trivial cases 
elseif M>D-M, R=D-M; D=uint64(1); return
else
  for N=64:-1:1
    s=bitget(R,64); R=bitsll(R,1); R=bitset(R,1,bitget(D,64)); D=bitsll(D,1);  
    if s, R=RR_sum64(R,M); else, R=RR_sum64(R,Mbar); end
    if bitget(R,64), D=bitset(D,1,0); else, D=bitset(D,1,1); end
  end
  if bitget(R,64), R=RR_sum64(R,M); end
end