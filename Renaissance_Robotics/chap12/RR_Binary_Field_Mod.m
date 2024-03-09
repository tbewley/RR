function r = RR_Binary_Field_Mod(b,a)
% function r = RR_Binary_Field_Mod(b,a)
% This function computes r = b mod a, where {r,b,a} are binary polynomials,
% with all arithmetic restricted to the binary Galois field GF(2^m).
% INPUT:  n=numerator
%         d=denomenator
% OUTPUT: r=remainder
% EXAMPLE #1: b=0b10000u64; a=0b10011u64; r=RR_Binary_Field_Mod(b,a)
% EXAMPLE #2: [see (7.26) in RR]
%    for i=1:15, a=0b0u64; a=bitset(a,i); r=RR_Binary_Field_Mod(a,0b10011u64); end
%    for i=1:15, a=0b0u64; a=bitset(a,i); r=RR_Binary_Field_Mod(a,0b10101u64); end
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 12)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

n=length(dec2bin(b)); m=length(dec2bin(a));
r=b;
for  i=n:-1:m    % zero coefficient i in b(z) by subtracting shift of a(z)
    if bitget(r,i), r=bitxor(r,bitshift(a,i-m)); end
end
% dec2bin(r,m-1)
