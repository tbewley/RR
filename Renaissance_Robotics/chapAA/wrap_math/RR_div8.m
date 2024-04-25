function [D,R]=RR_div8(Q,M)
% function [D,R]=RR_div8(Q,M)                      
% This code performs full uint8   by uint8   division using the nonrestoring division algorithm.
% RR_div8 generates pretty screen output to show how it works; RR_div64 is more streamlined.
% Both, of course, are slow compared to Matlab's built in / function (for uint8 through uint64). 
% INPUTS:  Q, M are uint8 (or single,double) Q=dividend, M=divisor
% OUTPUTS: D and R are uint8, with Q=D*M+R
% TEST:
%   clear, clc, Q=double(55+RR_randi(205)), M=double(RR_randi(150))
%   [D,R]=RR_div8(Q,M), fprintf('Check: (D*M+R)-Q = %d (should be zero), ',D*M+R-Q)
%   fprintf(' M-R = %d (should be positive)\n',double(M)-double(R))         
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

D=uint8(Q);   M=uint8(M);  Mbar=bitcmp(M)+1; R=uint8(0);  % Needs explicit type casting!
if M>Q,       D=uint8(0);  R=Q;   return  % skip algorithm below for the trivial cases 
elseif M>Q-M, D=uint8(1);  R=Q-M; return
else
  fprintf('M (in binary) = %s, Mbar (in binary) = %s\n',dec2bin(M,8),dec2bin(Mbar,8))
  disp('        N      R         D'),
  fprintf('        %d   %s  %s\n',0,dec2bin(R,8),dec2bin(D,8))
  for N=8:-1:1
    s=bitget(R,8);  R=bitsll(R,1); R=bitset(R,1,bitget(D,8));  D=bitsll(D,1);  
    fprintf('            %s  %s  (shift left)\n',dec2bin(R,8),dec2bin(D,8))
    if s, R=RR_sum8(R,M); c='add M'; else, R=RR_sum8(R,Mbar); c='add Mbar'; end
    if bitget(R,8),  D=bitset(D,1,0); else, D=bitset(D,1,1); end
    fprintf('        %d   %s  %s  <-- %s\n',N,dec2bin(R,8),dec2bin(D,8),c)
  end
  if bitget(R,8), R=RR_sum8(R,M); fprintf('       end  %s  %s  <-- add M\n',dec2bin(R,8),dec2bin(D,8))
 end
end

function [s,c]=RR_sum8(x,y)
% calculates [s,c]=x+y where {x,y,s,c} are uint8.  Intermediate math is uint64.
t=uint16(x)+uint16(y); s=uint8(bitand(t,0xFFu16)); c=uint8(bitsrl(t,8));
