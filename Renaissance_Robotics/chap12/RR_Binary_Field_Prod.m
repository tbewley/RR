function c = RR_Binary_Field_Prod(a,b)
% function r = RR_Binary_Field_Prod(b,a)
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

m=length(dec2bin(a)); n=length(dec2bin(b));
c=0b0u64;
for  i=1:m
    if bitget(a,i), c=bitxor(c,bitshift(b,i-1)); end
end

% m=length(a); n=length(b); p=zeros(1,n+m-1);
% for k=0:n-1; p=p+[zeros(1,n-1-k) b(n-k)*a zeros(1,k)]; end


% dec2bin(r,m-1)
