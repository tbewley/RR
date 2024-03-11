function [c,overflow]=RR_binary_add(a,b)
% function [c]=RR_binary_add(a,b)
% INPUTS:  a,b,      two binary strings, stored as character arrays, with the LSB to the right
% OUTPUTS: c         corresponding sum of a and b
%          overflow  flag that indicates if the sum is larger than the input character arrays.
% TEST:    [c,overflow]=RR_binary_add('1001','1011')
% NOTE! This simplistic code is NOT AT ALL efficient, and is meant for pedagogical purposes only.
% To accomplish binary addition efficiently, lower-level commands (in C or assembler) are required.
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Original code by Eric Verner, reproduced here with only minor tweaks.

a=[repmat('0',1,length(b)-length(a)) a]; % Make a and b of same length
b=[repmat('0',1,length(a)-length(b)) b]; n=length(a); carry=0;
for i=n:-1:1 
    w=str2num(a(i)) + str2num(b(i)) + carry; % Add the digits, one at a time
    switch w; 
      case 0, c(i)='0'; carry=0; 
      case 1, c(i)='1'; carry=0; 
      case 2, c(i)='0'; carry=1; 
      case 3, c(i)='1'; carry=1; 
    end
end
overflow=false;
if carry==1; c=['1' c]; if nargout==2; overflow=true; end, end
