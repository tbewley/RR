% classdef RR_uint512  
% A 512-bit unsigned integer class, built from 8 uint64 primatives, with wrap on overflow/underflow
% using two's complement notation.  Thus the following behavior (unlike Matlab's built-in functions):
%   A=RR_rand_RR_uint(512), B=-A, C=A+B  % gives C=0 [can replace 512 with anything from 1 to 1024...]
%
% RR defines unsigned integer division and remainder (unlike Matlab's built-in / operator)
% such that  B = (B/A)*A + R where the remainder R has value less than the value of B.  
% Thus the following behavior:
%   B=RR_rand_RR_uint(512), A=RR_rand_RR_uint(400)+1, [Q,R]=B/A, C=(Q*A+R)-B   % gives C=0.
%
% DEFINITION:
%   A=RR_uint512(hi,m6,m5,m4,m3,m2,m1,lo)
%   defines an RR_uint512 object from 8 uint64 variables, 0<=A<=2^512-1
%
% STANDARD OPERATIONS defined on RR_uint512 objects
% (overloading the +, -, *, /, ^, <, >, <=, >=, ~=, == operators):
%   plus:     [sum,carry]=a+b  gives the sum of two RR_uint512 integers
%   uminus:   -a gives the two's complement representation of negative a
%   minus:    b-a  gives the difference of two RR_uint512 integers (in two's complement form if negative)
%   mtimes:   [sum,carry]=a*b  gives the product of two RR_uint512 integers
%   mrdivide: [quo,rem]=b/a divides two RR_uint512 integers, giving the quotient quo and remainder rem
%   The relations <, >, <=, >=, ~=, == are also clearly defined.
%   {+,-,*} are built on uint64 primatives; the nonrestoring division algorithm is used to compute a/b
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

classdef RR_uint512 < matlab.mixin.CustomDisplay
    properties % RR_uint512 object OBJ consists of eight fields, with +,-,*,/ defined to wrap on overflow
        hi      % bits 449 to 512
        m6      % bits 385 to 448 
        m5      % bits 321 to 384
        m4      % bits 257 to 320
        m3      % bits 193 to 256
        m2      % bits 129 to 192 
        m1      % bits  65 to 128
        lo      % bits   1 to  64 
    end
    methods
        function OBJ = RR_uint512(a,b,c,d,e,f,g,h)  % create an RR_uint512 object obj.
            if nargin==1 % 1 argument:  create {hi,m6,m5,m4,m3,m2,m1,lo} parts from {0,0,0,0,0,0,0,a}            
                OBJ.hi=uint64(0); OBJ.m6=uint64(0); OBJ.m5=uint64(0); OBJ.m4=uint64(0); 
                OBJ.m3=uint64(0); OBJ.m2=uint64(0); OBJ.m1=uint64(0); OBJ.lo=uint64(a); 
            else         % 8 arguments: create {hi,m6,m5,m4,m3,m2,m1,lo} parts from {a,b,c,d,e,f,g,h}
                OBJ.hi=uint64(a); OBJ.m6=uint64(b); OBJ.m5=uint64(c); OBJ.m4=uint64(d); 
                OBJ.m3=uint64(e); OBJ.m2=uint64(f); OBJ.m1=uint64(g); OBJ.lo=uint64(h); 
            end
        end
        function [SUM,CARRY] = plus(A,B)       % Defines A+B using RR_uint256 math
            A=RR_uint512.check(A); B=RR_uint512.check(B);
            [AH,AL]=RR_512_to_256(A);          [BH,BL]=RR_512_to_256(B);
            [SH,SL,C1]=RR_HL_plus_L(AH,AL,BL); [SH,C2]=SH+BH; C=C1+C2;
            SUM=RR_256_to_512(SH,SL);          CARRY=RR_256_to_512(0,C);
        end
        function DIFF = minus(A,B)               % Defines A-B
            A=RR_uint512.check(A); B=RR_uint512.check(B);
            DIFF=A+(-B);
        end
        function OUT = uminus(B)                 % Defines (-B)
            B=RR_uint512.check(B);
            B=RR_uint512(bitcmp(B.hi),bitcmp(B.m6),bitcmp(B.m5),bitcmp(B.m4), ...
                         bitcmp(B.m3),bitcmp(B.m2),bitcmp(B.m1),bitcmp(B.lo)); OUT=B+1;
        end    
        function [PROD,CARRY] = mtimes(A,B)      % Defines A*B using RR_uint256 math
            A=RR_uint512.check(A); B=RR_uint512.check(B);
            [AH,AL]=RR_512_to_256(A); [BH,BL]=RR_512_to_256(B);
            [PH,PL,CL]=RR_HL_times_Y(AH,AL,BL);  % {CL PH PL}<-{AH AL} * BL   
            [P1,P2,CH]=RR_HL_times_Y(AH,AL,BH);  % {CH P1 P2}<-{AH AL} * BH 
            [CL,PH,C1]=RR_HL_plus_L(CL,PH,P2);   % {C1 CL PH}<-{CL PH} + {0 P2}
            CH=CH+C1; [CL,C2]=CL+P1; CH=CH+C2;   % CH<-CH+C1, {C2 CL}<-CL+P1, CH<-CH+C2
            PROD=RR_256_to_512(PH,PL); CARRY=RR_256_to_512(CH,CL);
        end
        function [QUO,RE] = mrdivide(B,A) % Defines [QUO,RE]=B/A
            A=RR_uint512.check(A); B=RR_uint512.check(B);
            [QUO,RE]=RR_div512(B,A);
        end

        % Now define a<b, a>b, a<=b, a>=b, a~=b, a==b based on the values of a and b.
        function tf=lt(A,B), A=RR_uint512.check(A); B=RR_uint512.check(B); [AH,AL]=RR_512_to_256(A); [BH,BL]=RR_512_to_256(B);
                             if (AH< BH) | (AH==BH & AL< BL), tf=true; else, tf=false; end, end            
        function tf=gt(A,B), A=RR_uint512.check(A); B=RR_uint512.check(B); [AH,AL]=RR_512_to_256(A); [BH,BL]=RR_512_to_256(B);
                             if (AH> BH) | (AH==BH & AL> BL), tf=true; else, tf=false; end, end
        function tf=le(A,B), A=RR_uint512.check(A); B=RR_uint512.check(B); [AH,AL]=RR_512_to_256(A); [BH,BL]=RR_512_to_256(B);
                             if (AH<=BH) | (AH==BH & AL<=BL), tf=true; else, tf=false; end, end
        function tf=ge(A,B), A=RR_uint512.check(A); B=RR_uint512.check(B); [AH,AL]=RR_512_to_256(A); [BH,BL]=RR_512_to_256(B);
                             if (AH>=BH) | (AH==BH & AL>=BL), tf=true; else, tf=false; end, end
        function tf=ne(A,B), A=RR_uint512.check(A); B=RR_uint512.check(B); [AH,AL]=RR_512_to_256(A); [BH,BL]=RR_512_to_256(B);
                             if (AH~=BH) | (AL~=BL),          tf=true; else, tf=false; end, end
        function tf=eq(A,B), A=RR_uint512.check(A); B=RR_uint512.check(B); [AH,AL]=RR_512_to_256(A); [BH,BL]=RR_512_to_256(B);
                             if (AH==BH) | (AL==BL),          tf=true; else, tf=false; end, end
        function s=sign(A), if A.v==0, s=0; else, s=1; end, end

        function A = RR_bitsll(A,k)            
            while k>63, A.hi=A.m6; A.m6=A.m5; A.m5=A.m4; A.m4=A.m3; 
                        A.m3=A.m2; A.m2=A.m1; A.m1=A.lo; A.lo=uint64(0); k=k-64; end
            A.hi=bitsll(A.hi,k); for i=1:k; A.hi=bitset(A.hi,i,bitget(A.m6,64-k+i)); end
            A.m6=bitsll(A.m6,k); for i=1:k; A.m6=bitset(A.m6,i,bitget(A.m5,64-k+i)); end
            A.m5=bitsll(A.m5,k); for i=1:k; A.m5=bitset(A.m5,i,bitget(A.m4,64-k+i)); end
            A.m4=bitsll(A.m4,k); for i=1:k; A.m4=bitset(A.m4,i,bitget(A.m3,64-k+i)); end
            A.m3=bitsll(A.m3,k); for i=1:k; A.m3=bitset(A.m3,i,bitget(A.m2,64-k+i)); end
            A.m2=bitsll(A.m2,k); for i=1:k; A.m2=bitset(A.m2,i,bitget(A.m1,64-k+i)); end
            A.m1=bitsll(A.m1,k); for i=1:k; A.m1=bitset(A.m1,i,bitget(A.lo,64-k+i)); end
            A.lo=bitsll(A.lo,k); 
        end
        function A = RR_bitsrl(A,k)            
            while k>63, A.lo=A.m1; A.m1=A.m2; A.m2=A.m3; A.m3=A.m4;
                        A.m4=A.m5; A.m5=A.m6; A.m6=A.hi; A.hi=uint64(0); k=k-64; end
            A.lo=bitsrl(A.lo,k); for i=1:k; A.lo=bitset(A.lo,64-k+i,bitget(A.m1,i)); end
            A.m1=bitsrl(A.m1,k); for i=1:k; A.m1=bitset(A.m1,64-k+i,bitget(A.m2,i)); end
            A.m2=bitsrl(A.m2,k); for i=1:k; A.m2=bitset(A.m2,64-k+i,bitget(A.m3,i)); end
            A.m3=bitsrl(A.m3,k); for i=1:k; A.m3=bitset(A.m3,64-k+i,bitget(A.m4,i)); end
            A.m4=bitsrl(A.m4,k); for i=1:k; A.m4=bitset(A.m4,64-k+i,bitget(A.m5,i)); end
            A.m5=bitsrl(A.m5,k); for i=1:k; A.m5=bitset(A.m5,64-k+i,bitget(A.m6,i)); end
            A.m6=bitsrl(A.m6,k); for i=1:k; A.m6=bitset(A.m6,64-k+i,bitget(A.hi,i)); end
            A.hi=bitsrl(A.hi,k); 
        end
        function [XH,XL]=RR_512_to_256(X)
            XH=RR_uint256(X.hi,X.m6,X.m5,X.m4); XL=RR_uint256(X.m3,X.m2,X.m1,X.lo);
        end
        function X=RR_512_to_1024(XH,XL)
            if ~isa(XH,'RR_uint512'), XH=RR_uint512(XH); end
            if ~isa(XL,'RR_uint512'), XL=RR_uint512(XL); end                
            X=RR_uint1024(XH.hi,XH.m6,XH.m5,XH.m4,XH.m3,XH.m2,XH.m1,XH.lo,...
                          XL.hi,XL.m6,XL.m5,XL.m4,XL.m3,XL.m2,XL.m1,XL.lo);
        end        
    end
    methods(Static)
        function A=check(A)
            if isa(A,'numeric'), A=RR_uint512(A);
            elseif ~isa(A,'RR_uint512'), A=RR_uint512(A.v); end
        end
    end
    methods(Access = protected)
        function displayScalarObject(OBJ)
            fprintf('RR_uint512 with {hi,m6,m5,m4} = {0x%s,0x%s,0x%s,0x%s}\n',dec2hex(OBJ.hi,16),dec2hex(OBJ.m6,16),dec2hex(OBJ.m5,16),dec2hex(OBJ.m4,16))
            fprintf('            and {m3,m2,m1,lo} = {0x%s,0x%s,0x%s,0x%s}\n',dec2hex(OBJ.m3,16),dec2hex(OBJ.m2,16),dec2hex(OBJ.m1,16),dec2hex(OBJ.lo,16))
        end
    end
end 
