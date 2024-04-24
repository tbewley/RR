function [dh,dl,r]=RR_div128s(xh,xl,y)
% function [dh,dl,r]=RR_div128s(xh,xl,y)
% This code performs uint128 by uint32 division using an algorithm from Knuth, leveraging uint64
% arithmetic.  Note: this code assumes y is nonzero only in its lowest 32 bits.
% This code is over 40x faster than the nonrestoring division algorithm (RR_div128) for problems
% at this size or smaller, but which are still to be to be addressed with uint64 or RR_uint64.
% INPUTS:  x={xh,xl}, y where {xh,xl,y} are each uint64 (or uint32,single,double)
% OUTPUTS: d={dh,dl} and r where {dh,dl,r} are uint64 and x=d*y+r
% TEST:    clear, clc, format hex
%          xh=RR_randi64, xl=RR_randi64, y=RR_randi64; y=bitsrl(y,32)
%          [dh,dl,r]=RR_div128s(xh,xl,y), disp('Check: Y=D*M+R, res=Y-Q.  Look for res=0, R<M.')
%          [ph,pl]=RR_prod128s(dh,dl,y);  % CHECK: calculate d*y+r
%          [XH,XL]=RR_sum128(ph,pl,0,r)   % in two steps.
%          disp('Note: {XH,XL} and {xh,xl} should match')
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Chapter 2)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License.

xh=uint64(xh); A=bitsra(xh,32); B=bitand(xh,0xFFFFFFFFu64); % {A,B}={hi,lo} 32 bits of xh
xl=uint64(xl); C=bitsra(xl,32); D=bitand(xl,0xFFFFFFFFu64); % {C,D}={hi,lo} 32 bits of xl
y=uint64(y);

% The key idea is to implement (A.a^3+B.a^2+C.a+D)/Y where {A,B,C,D,Y} are 32bit
% as follows (clever idea due to Knuth, volume 2, note that / denotes division and % remainder):
%      (A / Y) a^3 +                                        upper 32 bits of dh
%    (((A % Y) a + B) / Y) a^2 +                            lower 32 bits of dh
%  (((((A % Y) a + B) % Y) a + C) / Y) a +                  upper 32 bits of dl
% ((((((A % Y) a + B) % Y) a + C) % Y) a + D) / Y           lower 32 bits of dl

% PESKY BUG WORKAROUND IN MATLAB: as of Apr 2024, do NOT use / for division of integers in Matlab.
% https://www.mathworks.com/matlabcentral/answers/857225-how-does-division-work-for-integer-types

a=0x100000000;
t1=rem(A,y)*a +B;                 % t1=(A%Y)a+B             (in the notation of the comment above)
dh=idivide(A,y)*a +idivide(t1,y); 
t2=rem(t1,y)*a+C;                 % t2=(((A%Y)a+B)%Y)a+C
t3=rem(t2,y)*a+D;                 % t3=(((((A%Y)a+B)%Y)a+C)%Y)a+D
dl=idivide(t2,y)*a+idivide(t3,y); 

[ph,pl]  =RR_prod128s(dh,dl,y);                 % p={ph,pl}    where p=d*y
[mph,mpl]=RR_sum128s(bitcmp(ph),bitcmp(pl),1);  % mp={mph,mpl} where mp=-p (2's complement)
[rh,r]   =RR_sum128(xh,xl,mph,mpl);             % finally, calculate r=x-p where r={rh,rl}
