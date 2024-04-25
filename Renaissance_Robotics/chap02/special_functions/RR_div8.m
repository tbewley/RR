function [Q,R]=RR_div8(B,A)
% function [Q,R]=RR_div8(B,A)                      
% This code performs full uint8   by uint8   division using the nonrestoring division algorithm.
% RR_div8 generates pretty screen output to show how it works; RR_div64 is more streamlined.
% Both, of course, are slow compared to Matlab's built in / function (for uint8 through uint64). 
% INPUTS:  B, A are uint8 (or single,double) B=dividend, A=divisor
% OUTPUTS: Q and R are uint8, with B=Q*A+R
% TEST:
%   clear, clc, B=RR_randi8().v, A=RR_randi8(40).v
%   [Q,R]=RR_div8(B,A), fprintf('Check: Q*A+R = %u, which should equal B\n',Q*A+R)       
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

Q=uint8(B);   A=uint8(A);  Abar=bitcmp(A)+1; R=uint8(0);  % Needs explicit type casting!
if A>Q,       R=Q;   Q=uint8(0);  return  % skip algorithm below for the trivial cases 
elseif A>Q-A, R=Q-A; Q=uint8(1);  return
else
  fprintf('A (in binary) = %s, Abar (in binary) = %s\n',dec2bin(A,8),dec2bin(Abar,8))
  disp('        N      R         Q'),
  fprintf('        %d   %s  %s\n',0,dec2bin(R,8),dec2bin(Q,8))
  for N=8:-1:1
    s=bitget(R,8);  R=bitsll(R,1); R=bitset(R,1,bitget(Q,8));  Q=bitsll(Q,1);  
    fprintf('            %s  %s  (shift left)\n',dec2bin(R,8),dec2bin(Q,8))
    if s, R=RR_sum8(R,A); c='add A'; else, R=RR_sum8(R,Abar); c='add Abar'; end
    if bitget(R,8),  Q=bitset(Q,1,0); else, Q=bitset(Q,1,1); end
    fprintf('        %d   %s  %s  <-- %s\n',N,dec2bin(R,8),dec2bin(Q,8),c)
  end
  if bitget(R,8), R=RR_sum8(R,A); fprintf('       end  %s  %s  <-- add A\n',dec2bin(R,8),dec2bin(Q,8))
 end
end

function [s,c]=RR_sum8(x,y)
% calculates [s,c]=x+y where {x,y,s,c} are uint8.  Intermediate math is uint64.
t=uint16(x)+uint16(y); s=uint8(bitand(t,0xFFu16)); c=uint8(bitsrl(t,8));
