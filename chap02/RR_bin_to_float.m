function [f]=RR_bin_to_float(b)
% function [f]=RR_bin_to_float(b)
% INPUT:  b, an IEEE 754 floating-point form (stored, inefficiently, as a character array)
% OUTPUT: f, a Matlab double-precision floating-point number 
% TEST:   x=0.1, b=RR_float_to_bin(x), f=RR_bin_to_float(b)
%% Renaissance Robotics codebase, Chapter 2, https://github.com/tbewley/RR
%% Code written by Eric Verner, reproduced here in its entirity.  Downloaded from, and explanation at:
%% https://matlabgeeks.com/tips-tutorials/conversion-of-floating-point-numbers-from-binary-to-decimal/

if ~ischar(b)
  disp('Input must be a character string.');
  return;
end
hex = '0123456789abcdef'; %Hex characters
%Reshape into 4x(L/4) character array
bins = reshape(b,4,numel(b)/4).'; 
%Convert to numbers in range of (0-15)
nums = bin2dec(bins); 
%Convert to hex characters
hc = hex(nums + 1); 
%Convert from hex to float
f = hex2num(hc);