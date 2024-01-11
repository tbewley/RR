function [b]=RR_float_to_bin(f)
% function [b]=RR_float_to_bin(f)
% INPUT:  f, a Matlab double-precision floating-point number
% OUTPUT: b, the corresponding IEEE 754 floating-point form
% TEST:   b=RR_float_to_bin(0.1)
%% Renaissance Robotics codebase, Chapter 2, https://github.com/tbewley/RR
%% Code written by Eric Verner, reproduced here in its entirity.  Downloaded from, and explanation at:
%% https://matlabgeeks.com/tips-tutorials/conversion-of-floating-point-numbers-in-matlab/

%Input error handling
if ~isfloat(f)
  disp('Input must be a floating point number.');
  return;
end

%Hex characters
hex = '0123456789abcdef'; 

%Convert from float to hex
h = num2hex(f); 

%Convert to cell array of chars
hc = num2cell(h); 

%Convert to array of numbers
nums =  cellfun(@(x) find(hex == x) - 1, hc); 

%Convert to array of binary numbers
bins = dec2bin(nums, 4); 

%Reshape into horizontal vector
b = reshape(bins.', 1, numel(bins));
