function [f]=RR_bin_to_float(b)
% function [f]=RR_bin_to_float(b)
% INPUT:  b, an IEEE 754 floating-point form (stored, inefficiently, as a character array)
% OUTPUT: f, a Matlab double-precision floating-point number 
% TEST:   x=0.1, b=RR_float_to_bin(x), f=RR_bin_to_float(b)
%% Renaissance Robotics codebase, Chapter 2, https://github.com/tbewley/RR
%% Code written by Eric Verner, with minor formatting changes here. Downloaded from and explained at:
%% https://matlabgeeks.com/tips-tutorials/conversion-of-floating-point-numbers-from-binary-to-decimal/

if ~ischar(b), error('Input must be a character string.'); end
hex = '0123456789abcdef';         % Define the hex characters
bins = reshape(b,4,numel(b)/4).'; % Reshape into 4x(L/4) character array
nums = bin2dec(bins);             % Convert to numbers in the range of (0-15)
hc = hex(nums + 1);               % Convert to hex characters
f = hex2num(hc);                  % Convert from hex to float