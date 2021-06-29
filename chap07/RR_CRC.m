function [b] = RR_CRC(d,v,k,r,verbose)
% function w = RR_CRC(d,v,k,r,verbose)
% Encodes the binary data vector d(z) using the cyclic basis polynomial v(z).
% Note: all polynomials ordered from highest power to zero'th power of z in vectors.
% INPUTS: d=vector of binary (logical) coefficients of the data polynomial
%         v=vector of binary (logical) coefficients of the basis polynomial 
%         k=number of data bits (size of d)
%         r=number of parity bits (r+1 = size of v)
% OUTPUT: b=vector of redundant coefficients of the corresponding codeword polynomial
% NOTE 1: In systematic cyclic form, the resulting codeword is [d b].
% NOTE 2: This demo code is by no means efficient, use for demo purposes only.
% NOTE 3: This demo code requires k+r<=64.
% EXAMPLE CALL #1: [encodes/decodes a given binary vector d using CRC-5-USB]:
%     k=16; r=5; d=0b1101100111011010u64; v=0b100101u64;
%     [b]=RR_CRC(d,v,k,r,true)
% EXAMPLE CALL #2: [encodes/decodes a random binary vector d using CRC-32 (ethernet)]:
%     k=32; r=32; ds=sprintf('%d',rand(1,k)>.5), d=eval(strcat('0b',ds,'u64'));
%     v=0b100000100110000010001110110110111u64;  % (note the 1 added to the end!)
%     [b]=RR_CRC(d,v,k,r,false)
% Renaissance Robotics codebase, Chapter 7, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under BSD 3-Clause License.

if ~verbose,
  t=bitshift(d,r); 
  for  i=k+r:-1:r+1
    if bitget(t,i), t=bitxor(t,bitshift(v,i-r-1)); end
  end
  b=dec2bin(t,r);
else
  t=bitshift(d,r); temp=dec2bin(t,k+r)
  for  i=k+r:-1:r+1
    if bitget(t,i),
      w=bitshift(v,i-r-1); divisor=dec2bin(w,k+r)
      t=bitxor(t,w);       temp   =dec2bin(t,k+r)
    end
  end
  b=dec2bin(t,r);
end