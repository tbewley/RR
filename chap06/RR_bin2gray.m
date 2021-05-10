function g=RR_bin2gray(b)
% function g=RR_bin2gray(b)
% Converts from binry to Gray code
% INPUT:  in=binary number [generate, e.g., via dec2bin(int)]
% OUTPUT: g=corresponding Gray form
% EXAMPLE CALL: for d=0:15, b=dec2bin(d); g=RR_bin2gray(b); disp({d b g}), end
% open-source algorithm from https://www.matrixlab-examples.com/gray-code.html

g(1)=b(1);
for i=2:length(b);
    x=xor(str2num(b(i-1)),str2num(b(i))); g(i)=num2str(x);
end
