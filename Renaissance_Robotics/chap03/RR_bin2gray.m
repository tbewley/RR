function g=RR_bin2gray(b)
% function g=RR_bin2gray(b)
% Converts from binry to Gray code
% INPUT:  in=binary number [generate, e.g., via dec2bin(int)]
% OUTPUT: g=corresponding Gray form
% EXAMPLE CALL: for d=0:31, b=dec2bin(d); g=RR_bin2gray(b); disp({d b g}), end
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/RR_chap03
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

g(1)=b(1);
for j=1:length(b)-1;
    g(j+1)=num2str(xor(str2num(b(j)),str2num(b(j+1))));
end