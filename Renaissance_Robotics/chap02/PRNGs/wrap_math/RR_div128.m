function [dh,dl,rh,rl]=RR_div128(xh,xl,yh,yl)
% function [dh,dl,rh,rl]=RR_div128(xh,xl,yh,yl)
% This code performs uint128 by uint128 division using the nonrestoring division algorithm.
% INPUTS:  x={xh,xl}, y={yh,yl} where {xh,xl,yh,yl} are each uint64 (or uint32,single,double)
% OUTPUTS: d={dh,dl} and r={rh,rl} where {dh,dl,rh,rl} are uint64 and x=d*y+r
% TEST:    xh=0x32E7613DA165B216, xl=0x4D9DAB159C256304, y=0x13CFB07B35AE5CB
%          [dh,dl,rh,rl]=RR_div128s(xh,xl,y)
%          [ph,pl]=RR_prod128s(dh,dl,y); [xhc,xhl]=RR_sum128(dh,dl,rh,rl)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

xh=uint64(xh); A=bitsra(xh,32); B=bitand(xh,0xFFFFFFFFu64); % {A,B}={hi,lo} 32 bits of xh
xl=uint64(xl); C=bitsra(xl,32); D=bitand(xl,0xFFFFFFFFu64); % {C,D}={hi,lo} 32 bits of xl
y=uint64(y);

% The key idea is to implement (A.a^3+B.a^2+C.a+D)/Y where {A,B,C,D} are 32bit and Y is 64bit
% as follows (clever idea due to Knuth, volume 2, note that / denotes division and % remainder):
%      (A / Y) a^3 +                                        upper 32 bits of dh
%    (((A % Y) a + B) / Y) a^2 +                            lower 32 bits of dh
%  (((((A % Y) a + B) % Y) a + C) / Y) a +                  upper 32 bits of dl
% ((((((A % Y) a + B) % Y) a + C) % Y) a + D) / Y           lower 32 bits of dl

% PESKY BUG WORKAROUND IN MATLAB: as of Apr 2024, do not use / for division of integers in Matlab.
% https://www.mathworks.com/matlabcentral/answers/857225-how-does-division-work-for-integer-types

a=0x100000000;
t1=rem(A,y)*a +B;                 % t1=(A%Y)a+B             (in the notation of the comment above)
dh=idivide(A,y)*a +idivide(t1,y); 
t2=rem(t1,y)*a+C;                 % t2=(((A%Y)a+B)%Y)a+C
t3=rem(t2,y)*a+D;                 % t3=(((((A%Y)a+B)%Y)a+C)%Y)a+D
dl=idivide(t2,y)*a+idivide(t3,y); 

[ph,pl]  =RR_prod128s(dh,dl,y);                 % p={ph,pl}    where p=d*y
[mph,mpl]=RR_sum128s(bitcmp(ph),bitcmp(pl),1);  % mp={mph,mpl} where mp=-p (2's complement)
[rh,rl]  =RR_sum128(xh,xl,mph,mpl);             % finally, calculate r=x-p where r={rh,rl}
