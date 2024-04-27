% classdef RR_uint1024
% A 1024-bit unsigned integer class, built from 16 uint64 primatives, with wrap on overflow/underflow
% using two's complement notation.  Thus the following behavior (unlike Matlab's built-in functions):
%   A=RR_randi1024, B=-A, C=A+B  % gives C=0 [can replace 1024 with any of {8,16,32,64,128,256,512,1024}]
%
% RR defines unsigned integer division and remainder (unlike Matlab's built-in / operator)
% such that  B = (B/A)*A + R where the remainder R has value less than the value of B.  
% Thus the following behavior: [can replace 1024 with any of {8,16,32,64,128,256,512,1024,1024}]
%   B=RR_randi1024, A=RR_randi1024(800), [Q,R]=B/A, C=(Q*A+R)-B  % gives C=0.
%
% DEFINITION:
%   A=RR_uint1024(hi,m14,m13,m12,m11,m10,m9,m8,m7,m6,m5,m4,m3,m2,m1,lo)
%   defines an RR_uint1024 object from 16 uint64 variables, 0<=A<=2^1024-1
%
% STANDARD OPERATIONS defined on RR_uint1024 objects
% (overloading the +, -, *, /, ^, <, >, <=, >=, ~=, == operators):
%   plus:     [sum,carry]=a+b  gives the sum of two RR_uint1024 integers
%   uminus:   -a gives the two's complement representation of negative a
%   minus:    b-a  gives the difference of two RR_uint1024 integers (in two's complement form if negative)
%   mtimes:   [sum,carry]=a*b  gives the product of two RR_uint1024 integers
%   mrdivide: [quo,rem]=b/a divides two RR_uint1024 integers, giving the quotient quo and remainder rem
%   The relations <, >, <=, >=, ~=, == are also clearly defined.
%   {+,-,*} are built on uint64 primatives; the nonrestoring division algorithm is used to compute a/b
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

classdef RR_uint1024 < matlab.mixin.CustomDisplay
    properties % RR_uint1024 object OBJ consists of 16 fields, with +,-,*,/ defined to wrap on overflow
        hi      % bits 961 to 1024
        m14     % bits 897 to  960 
        m13     % bits 833 to  896
        m12     % bits 769 to  832
        m11     % bits 705 to  768
        m10     % bits 641 to  704 
        m9      % bits 577 to  640
        m8      % bits 513 to  576
        m7      % bits 449 to  512
        m6      % bits 385 to  448 
        m5      % bits 321 to  384
        m4      % bits 257 to  320
        m3      % bits 193 to  256
        m2      % bits 129 to  192 
        m1      % bits  65 to  128
        lo      % bits   1 to   64
    end
    methods
        function OBJ = RR_uint1024(a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p)  % create an object
            if nargin==1 % 1 argument:  create parts from {0,...,0,a}            
                OBJ.hi =uint64(0); OBJ.m14=uint64(0); OBJ.m13=uint64(0); OBJ.m12=uint64(0); 
                OBJ.m11=uint64(0); OBJ.m10=uint64(0); OBJ.m9 =uint64(0); OBJ.m8 =uint64(0); 
                OBJ.m7 =uint64(0); OBJ.m6 =uint64(0); OBJ.m5 =uint64(0); OBJ.m4 =uint64(0); 
                OBJ.m3 =uint64(0); OBJ.m2 =uint64(0); OBJ.m1 =uint64(0); OBJ.lo =uint64(a); 
            else         % 16 arguments: create parts from {a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p}
                OBJ.hi =uint64(a); OBJ.m14=uint64(b); OBJ.m13=uint64(c); OBJ.m12=uint64(d); 
                OBJ.m11=uint64(e); OBJ.m10=uint64(f); OBJ.m9 =uint64(g); OBJ.m8 =uint64(h); 
                OBJ.m7 =uint64(i); OBJ.m6 =uint64(j); OBJ.m5 =uint64(k); OBJ.m4 =uint64(l); 
                OBJ.m3 =uint64(m); OBJ.m2 =uint64(n); OBJ.m1 =uint64(o); OBJ.lo =uint64(p); 
            end
        end
        function [SUM,CARRY] = plus(X,Y)         % Defines X+Y using RR_uint512 math
            [XH,XL]=RR_1024_to_512(X);         [YH,YL]=RR_1024_to_512(Y);
            [SH,SL,C1]=RR_HL_plus_L(XH,XL,YL); [SH,C2]=SH+YH; C=C1+C2;
            SUM=RR_512_to_1024(SH,SL);         CARRY=RR_512_to_1024(0,C);
        end
        function DIFF = minus(A,B)               % Defines A-B
            DIFF=A+(-B);
        end
        function OUT = uminus(B)                 % Defines (-B)
            B=RR_uint1024(bitcmp(B.hi ),bitcmp(B.m14),bitcmp(B.m13),bitcmp(B.m12), ...
                          bitcmp(B.m11),bitcmp(B.m10),bitcmp(B.m9 ),bitcmp(B.m8 ), ...
                          bitcmp(B.m7 ),bitcmp(B.m6 ),bitcmp(B.m5 ),bitcmp(B.m4 ), ...
                          bitcmp(B.m3 ),bitcmp(B.m2 ),bitcmp(B.m1 ),bitcmp(B.lo )); OUT=B+RR_uint1024(1);
        end    
        function [PROD,CARRY] = mtimes(X,Y)      % Defines X*Y using RR_uint256 math
            [XH,XL]=RR_1024_to_512(X); [YH,YL]=RR_1024_to_512(Y);
            [PH,PL,CL]=RR_HL_times_Y(XH,XL,YL);  % {CL PH PL}<-{XH XL} * YL   
            [P1,P2,CH]=RR_HL_times_Y(XH,XL,YH);  % {CH P1 P2}<-{XH XL} * YH 
            [CL,PH,C1]=RR_HL_plus_L(CL,PH,P2);   % {C1 CL PH}<-{CL PH} + {0 P2}
            CH=CH+C1; [CL,C2]=CL+P1; CH=CH+C2;   % CH<-CH+C1, {C2 CL}<-CL+P1, CH<-CH+C2
            PROD=RR_512_to_1024(PH,PL); CARRY=RR_512_to_1024(CH,CL);
        end
        function [QUO,RE] = mrdivide(B,A) % Defines [QUO,RE]=B/A
            [QUO,RE]=RR_div1024(B,A);
        end

        % Now define a<b, a>b, a<=b, a>=b, a~=b, a==b based on the values of a and b.
        function tf=lt(A,B), [AH,AL]=RR_1024_to_512(A); [BH,BL]=RR_1024_to_512(B); if (AH< BH) | (AH==BH & AL< BL), tf=true; else, tf=false; end, end            
        function tf=gt(A,B), [AH,AL]=RR_1024_to_512(A); [BH,BL]=RR_1024_to_512(B); if (AH> BH) | (AH==BH & AL> BL), tf=true; else, tf=false; end, end
        function tf=le(A,B), [AH,AL]=RR_1024_to_512(A); [BH,BL]=RR_1024_to_512(B); if (AH<=BH) | (AH==BH & AL<=BL), tf=true; else, tf=false; end, end
        function tf=ge(A,B), [AH,AL]=RR_1024_to_512(A); [BH,BL]=RR_1024_to_512(B); if (AH>=BH) | (AH==BH & AL>=BL), tf=true; else, tf=false; end, end
        function tf=ne(A,B), [AH,AL]=RR_1024_to_512(A); [BH,BL]=RR_1024_to_512(B); if (AH~=BH) | (AL~=BL),          tf=true; else, tf=false; end, end
        function tf=eq(A,B), [AH,AL]=RR_1024_to_512(A); [BH,BL]=RR_1024_to_512(B); if (AH==BH) | (AL==BL),          tf=true; else, tf=false; end, end
        function s=sign(A), if A.v==0, s=0; else, s=1; end, end

        function A = RR_bitsll(A,k)            
            while k>63, A.hi =A.m14; A.m14=A.m13; A.m13=A.m12; A.m12=A.m11; 
                        A.m11=A.m10; A.m10=A.m9;  A.m9 =A.m8;  A.m8 =A.m7; 
                        A.h7 =A.m6;  A.m6 =A.m5;  A.m5 =A.m4;  A.m4 =A.m3; 
                        A.m3 =A.m2;  A.m2 =A.m1;  A.m1 =A.lo;  A.lo =uint64(0); k=k-64; end
            A.hi =bitsll(A.hi ,k); for i=1:k; A.hi =bitset(A.hi ,i,bitget(A.m14,64-k+i)); end
            A.m14=bitsll(A.m14,k); for i=1:k; A.m14=bitset(A.m14,i,bitget(A.m13,64-k+i)); end
            A.m13=bitsll(A.m13,k); for i=1:k; A.m13=bitset(A.m13,i,bitget(A.m12,64-k+i)); end
            A.m12=bitsll(A.m12,k); for i=1:k; A.m12=bitset(A.m12,i,bitget(A.m11,64-k+i)); end
            A.m11=bitsll(A.m11,k); for i=1:k; A.m11=bitset(A.m11,i,bitget(A.m10,64-k+i)); end
            A.m10=bitsll(A.m10,k); for i=1:k; A.m10=bitset(A.m10,i,bitget(A.m9 ,64-k+i)); end
            A.m9 =bitsll(A.m9 ,k); for i=1:k; A.m9 =bitset(A.m9 ,i,bitget(A.m8 ,64-k+i)); end
            A.m8 =bitsll(A.m8 ,k); for i=1:k; A.m8 =bitset(A.m8 ,i,bitget(A.m7 ,64-k+i)); end
            A.m7 =bitsll(A.m7 ,k); for i=1:k; A.m7 =bitset(A.m7 ,i,bitget(A.m6 ,64-k+i)); end
            A.m6 =bitsll(A.m6 ,k); for i=1:k; A.m6 =bitset(A.m6 ,i,bitget(A.m5 ,64-k+i)); end
            A.m5 =bitsll(A.m5 ,k); for i=1:k; A.m5 =bitset(A.m5 ,i,bitget(A.m4 ,64-k+i)); end
            A.m4 =bitsll(A.m4 ,k); for i=1:k; A.m4 =bitset(A.m4 ,i,bitget(A.m3 ,64-k+i)); end
            A.m3 =bitsll(A.m3 ,k); for i=1:k; A.m3 =bitset(A.m3 ,i,bitget(A.m2 ,64-k+i)); end
            A.m2 =bitsll(A.m2 ,k); for i=1:k; A.m2 =bitset(A.m2 ,i,bitget(A.m1 ,64-k+i)); end
            A.m1 =bitsll(A.m1 ,k); for i=1:k; A.m1 =bitset(A.m1 ,i,bitget(A.lo ,64-k+i)); end
            A.lo =bitsll(A.lo ,k); 
        end
        function A = RR_bitsrl(A,k)            
            while k>63, A.lo =A.m1;  A.m1 =A.m2;  A.m2 =A.m3;  A.m3 =A.m4;
                        A.m4 =A.m5;  A.m5 =A.m6;  A.m6 =A.m7;  A.m7 =A.m8;
                        A.m8 =A.m9;  A.m9 =A.m10; A.m10=A.m11; A.m11=A.m12;
                        A.m12=A.m13; A.m13=A.m14; A.m14=A.hi;  A.hi=uint64(0); k=k-64; end
            A.lo =bitsrl(A.lo ,k); for i=1:k; A.lo =bitset(A.lo ,64-k+i,bitget(A.m1 ,i)); end
            A.m1 =bitsrl(A.m1 ,k); for i=1:k; A.m1 =bitset(A.m1 ,64-k+i,bitget(A.m2 ,i)); end
            A.m2 =bitsrl(A.m2 ,k); for i=1:k; A.m2 =bitset(A.m2 ,64-k+i,bitget(A.m3 ,i)); end
            A.m3 =bitsrl(A.m3 ,k); for i=1:k; A.m3 =bitset(A.m3 ,64-k+i,bitget(A.m4 ,i)); end
            A.m4 =bitsrl(A.m4 ,k); for i=1:k; A.m4 =bitset(A.m4 ,64-k+i,bitget(A.m5 ,i)); end
            A.m5 =bitsrl(A.m5 ,k); for i=1:k; A.m5 =bitset(A.m5 ,64-k+i,bitget(A.m6 ,i)); end
            A.m6 =bitsrl(A.m6 ,k); for i=1:k; A.m6 =bitset(A.m6 ,64-k+i,bitget(A.m7 ,i)); end
            A.m7 =bitsrl(A.m7 ,k); for i=1:k; A.m7 =bitset(A.m7 ,64-k+i,bitget(A.m8 ,i)); end
            A.m8 =bitsrl(A.m8 ,k); for i=1:k; A.m8 =bitset(A.m8 ,64-k+i,bitget(A.m9 ,i)); end
            A.m9 =bitsrl(A.m9 ,k); for i=1:k; A.m9 =bitset(A.m9 ,64-k+i,bitget(A.m10,i)); end
            A.m10=bitsrl(A.m10,k); for i=1:k; A.m10=bitset(A.m10,64-k+i,bitget(A.m11,i)); end
            A.m11=bitsrl(A.m11,k); for i=1:k; A.m11=bitset(A.m11,64-k+i,bitget(A.m12,i)); end
            A.m12=bitsrl(A.m12,k); for i=1:k; A.m12=bitset(A.m12,64-k+i,bitget(A.m13,i)); end
            A.m13=bitsrl(A.m13,k); for i=1:k; A.m13=bitset(A.m13,64-k+i,bitget(A.m14,i)); end
            A.m14=bitsrl(A.m14,k); for i=1:k; A.m14=bitset(A.m14,64-k+i,bitget(A.hi ,i)); end
            A.hi =bitsrl(A.hi ,k); 
        end
        function [XH,XL]=RR_1024_to_512(X)
            XH=RR_uint512(X.hi,X.m14,X.m13,X.m12,X.m11,X.m10,X.m9,X.m8);
            XL=RR_uint512(X.m7,X.m6 ,X.m5 ,X.m4 ,X.m3 ,X.m2 ,X.m1,X.lo);
        end
    end
    methods(Access = protected)
        function displayScalarObject(OBJ)
            fprintf('RR_uint1024 with {hi ,m14,m13,m12} = {0x%s,0x%s,0x%s,0x%s}\n',dec2hex(OBJ.hi ,16),dec2hex(OBJ.m14,16),dec2hex(OBJ.m13,16),dec2hex(OBJ.m12,16))
            fprintf('             and {m11,m10,m9 ,m8 } = {0x%s,0x%s,0x%s,0x%s}\n',dec2hex(OBJ.m11,16),dec2hex(OBJ.m10,16),dec2hex(OBJ.m9 ,16),dec2hex(OBJ.m8 ,16))
            fprintf('             and {m7 ,m6 ,m5 ,m4 } = {0x%s,0x%s,0x%s,0x%s}\n',dec2hex(OBJ.m7 ,16),dec2hex(OBJ.m6 ,16),dec2hex(OBJ.m5 ,16),dec2hex(OBJ.m4 ,16))
            fprintf('             and {m3 ,m2 ,m1 ,lo } = {0x%s,0x%s,0x%s,0x%s}\n',dec2hex(OBJ.m3 ,16),dec2hex(OBJ.m2 ,16),dec2hex(OBJ.m1 ,16),dec2hex(OBJ.lo ,16))
        end
    end
end 
