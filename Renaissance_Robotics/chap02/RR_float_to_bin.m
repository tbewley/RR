function [b]=RR_float_to_bin(f)
% function [b]=RR_float_to_bin(f)
% INPUT:  f, a Matlab double-precision floating-point number
% OUTPUT: b, the corresponding IEEE 754 floating-point form
% TEST:   b=RR_float_to_bin(0.1)
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/RR_chap02
%% Code written by Eric Verner, with minor formatting changes here. Downloaded from, and explanation at:
%% https://matlabgeeks.com/tips-tutorials/conversion-of-floating-point-numbers-in-matlab/

if ~isfloat(f), error('Input must be a floating point number.'); end
hex  = '0123456789abcdef';                   % Define the hex characters
h    = num2hex(f);                           % Convert from float to hex
hc   = num2cell(h);                          % Convert to cell array of chars
nums = cellfun(@(x) find(hex == x) - 1, hc); % Convert to array of numbers
bins = dec2bin(nums, 4);                     % Convert to array of binary numbers
b    = reshape(bins.', 1, numel(bins));      % Reshape into horizontal vector