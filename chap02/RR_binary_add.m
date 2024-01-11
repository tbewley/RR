function [c,overflow]=RR_binary_add(a,b)
% function [c]=RR_binary_add(a,b)
% INPUTS:  a,b,      two binary strings, stored as character arrays, with the LSB to the right
% OUTPUTS: c         corresponding sum of a and b
%          overflow  flag that indicates if the sum is larger than the input character arrays.
% TEST:    c=RR_binary_add('01001','11')
% NOTE! This code is NOT AT ALL efficient, and is meant for pedagogical purposes only.
% To accomplish binary addition efficiently, lower-level commands (in C or assembler) are required.
%% Renaissance Robotics codebase, Chapter 2, https://github.com/tbewley/RR
%% Code written by Eric Verner, reproduced here in its entirity.

a=[repmat('0',1,length(b)-length(a)) a]; % Make a and b of same lengths
b=[repmat('0',1,length(a)-length(b)) b]; n=length(b); rem=0;
a, b
for i=n:-1:1                             % Add the binary numbers
    w=str2num(a(i)) + str2num(b(i)) + rem
    switch str2num(a(i)) + str2num(b(i)) + rem;
      case 0, c(i)='0'; rem=0; 
      case 1, c(i)='1'; rem=0; 
      case 2, c(i)='0'; rem=1; 
      case 3, c(i)='1'; rem=1; 
    end
end
overflow=false;
if rem==1; if nargout==2; overflow=true; c=['1' c]; end
