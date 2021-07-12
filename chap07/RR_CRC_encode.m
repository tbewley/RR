function b = RR_CRC(a,v,k,r,verbose)
% function b = RR_CRC(a,v,k,r,verbose)
% Encodes the binary data vector a(z) using the cyclic basis polynomial v(z).
% Note: all polynomials ordered from highest power to zero'th power of z in vectors.
% INPUTS: a=vector of binary (logical) coefficients of the data polynomial a(z)
%         v=vector of binary (logical) coefficients of the basis polynomial v(z)
%         k=number of data bits (size of a)
%         r=number of parity bits (r+1 = size of v)
% OUTPUT: b=vector of coefficients of the corresponding codeword polynomial b(z)
% NOTE 1: This demo code is by no means efficient, use for demo purposes only.
% NOTE 2: This demo code requires k+r<=64.
% NOTE 3: In systematic cyclic form, the resulting codeword is [a b].
% EXAMPLE CALL #1: [encodes/decodes a given binary vector a using CRC-5-USB]:
%     k=16; r=5; a=0b1101100111011010u64; v=0b100101u64;
%     [b]=RR_CRC(a,v,k,r,true)
% EXAMPLE CALL #2: [encodes/decodes a random binary vector a using CRC-32 (802.3)]
%     k=32; r=32; as=sprintf('%d',rand(1,k)>.5), a=eval(strcat('0b',as,'u64'));
%     v=0b100000100110000010001110110110111u64;  % (note the 1 added to the end!)
%     [b]=RR_CRC(a,v,k,r,false)
% Renaissance Robotics codebase, Chapter 7, https://github.com/tbewley/RR
% Copyright 2021 by Thomas Bewley, distributed under BSD 3-Clause License.

if ~verbose
  t=bitshift(a,r);
  for  i=k+r:-1:r+1
    if bitget(t,i), t=bitxor(t,bitshift(v,i-r-1)); end
  end
  b=dec2bin(t,r);
else                                  % (same as above, with more screen output)
  t=bitshift(a,r); ts=dec2bin(t,k+r)
  for  i=k+r:-1:r+1
    if bitget(t,i)
      w=bitshift(v,i-r-1); vs=dec2bin(w,k+r)
      t=bitxor(t,w);       ts=dec2bin(t,k+r)
    end
  end
  b=dec2bin(t,r)
end
