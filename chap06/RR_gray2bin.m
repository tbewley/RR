function b=gray2bin(g)
% function b=gray2bin(g)
% INPUT:  g=Gray code number
% OUTPUT: b=corresponding binary number
% EXAMPLE CALL: d=87, b=dec2bin(d), g=bin2gray(b), b1=gray2bin(g)
% open-source algorithm from https://www.matrixlab-examples.com/gray-code.html

b(1)=g(1);
for i=2:length(g)
    x=xor(str2num(b(i-1)),str2num(g(i))); b(i)=num2str(x);
end
