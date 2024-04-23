% classdef RR_uint256
% This class developes a uint256 type (built with four uint64 types) with wrap on overflow.
%
% DEFINITION:
%   A=RR_uint256(hi,m2,m1,lo) defines an RR_uint256 object from 4 uint64 variables, 0<=A<=2^256-1=1.16e+77
%
% STANDARD OPERATIONS defined on RR_uint256 objects
% (overloading the +, -, *, /, ^, <, >, <=, >=, ~=, == operators):
%   plus:     [sum,carry]=a+b  gives the sum of two RR_uint256 integers
%   uminus:   -a gives the two's complement representation of negative a
%   minus:    b-a  gives the difference of two RR_uint256 integers (in two's complement form if negative)
%   mtimes:   [sum,carry]=a*b  gives the product of two RR_uint256 integers
%   mrdivide: [quo,rem]=b/a divides two RR_uint256 integers, giving the quotient quo and remainder rem
%   The relations <, >, <=, >=, ~=, == are also clearly defined.
%   {+,-,*} are built on uint64 primatives; the nonrestoring division algorithm is used to compute a/b
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

classdef RR_uint256 < matlab.mixin.CustomDisplay
    properties % RR_uint256 object OBJ consists of four fields, with +,-,*,/ defined to wrap on overflow
        hi      % bits 193 to 256
        m2      % bits 129 to 192 
        m1      % bits  65 to 128
        lo      % bits   1 to  64 
    end
    methods
        function OBJ = RR_uint256(a,b,c,d)  % create an RR_uint256 object obj.
            if nargin==1          % one argument: create {hi,m2,m1,lo} parts from {0,0,0,a}            
                OBJ.hi=uint64(0); OBJ.m2=uint64(0); OBJ.m1=uint64(0); OBJ.lo=uint64(a); 
            else                  % four arguments: create {hi,m2,m1,lo} parts from {a,b,c,d}
                OBJ.hi=uint64(a); OBJ.m2=uint64(b); OBJ.m1=uint64(c); OBJ.lo=uint64(d); 
            end
        end
        function [SUM,CARRY] = plus(X,Y)       % Defines X+Y using RR_uint128 math
            XH=RR_uint128(X.hi,X.m2); XL=RR_uint128(X.m1,X.lo);
            YH=RR_uint128(Y.hi,Y.m2); YL=RR_uint128(Y.m1,Y.lo);

            [SH,SL,C1]=RR_sum256s(XH,XL,YL); [SH,C2]=SH+YH; C=C1+C2;

            SUM=RR_uint256(SH.h,SH.l,SL.h,SL.l); CARRY=RR_uint256(0,0,C1.h,C1.l);
        end
        function DIFF = minus(A,B)            % Defines A-B
            DIFF=A+(-B);
        end
        function OUT = uminus(B)              % Defines (-B)
            B=RR_uint256(bitcmp(B.hi),bitcmp(B.m2),bitcmp(B.m1),bitcmp(B.lo)); OUT=B+RR_uint256(1);
        end    
        function [PROD,CARRY] = mtimes(X,Y)   % Defines X*Y using RR_uint128 math
            XH=RR_uint128(X.hi,X.m2); XL=RR_uint128(X.m1,X.lo); 
            YH=RR_uint128(Y.hi,Y.m2); YL=RR_uint128(Y.m1,Y.lo);

            [PH,PL,CL] =RR_prod256s(XH,XL,YL);          % {CL PH PL} <- {XH XL} * YL   
            [P1,P2,CH] =RR_prod256s(XH,XL,YH);          % {CH P1 P2} <- {XH XL} * YH 

            [CL,PH,C1]=RR_sum256s(CL,PH,P2);            % {C1 CL PH} <- {CL PH} + {0 P2}
            CH=CH+C1;                                   %         CH <- CH+C1
            [CL,C2]=CL+P1;                              %    {C2 CL} <- CL+P1
            CH=CH+C2;                                   %         CH <- CH+C2

%             {XH XL}     This graphic summarizes how the above calculations are combined.
%           * {YH YL}     (should be self explanatory)
% -------------------
%          {CL PH PL}
%     + {CH P1 P2}
% -------------------
%       {CH CL PH PL}

            PROD =RR_uint256(PH.h,PH.l,PL.h,PL.l);
            CARRY=RR_uint256(CH.h,CH.l,CL.h,CL.l);
        end
        function [QUO,RE] = mrdivide(B,A) % Defines [QUO,RE]=B/A
            [QUO,RE]=RR_div256(B,A);
        end
        function n = norm(A), n=abs(A.v); end                              % Defines norm(A)          
        % Now define a<b, a>b, a<=b, a>=b, a~=b, a==b based on the values of a and b.
        function tf=lt(A,B), if (A.hi< B.hi) | (A.hi==B.hi & A.m2< B.m2) | (A.hi==B.hi & A.m2==B.m2 & A.m1< B.m1) | (A.hi==B.hi & A.m2==B.m2 & A.m1==B.m1 & A.lo< B.lo), tf=true; else, tf=false; end, end            
        function tf=gt(A,B), if (A.hi> B.hi) | (A.hi==B.hi & A.m2> B.m2) | (A.hi==B.hi & A.m2==B.m2 & A.m1> B.m1) | (A.hi==B.hi & A.m2==B.m2 & A.m1==B.m1 & A.lo> B.lo), tf=true; else, tf=false; end, end
        function tf=le(A,B), if (A.hi<=B.hi) | (A.hi==B.hi & A.m2<=B.m2) | (A.hi==B.hi & A.m2==B.m2 & A.m1<=B.m1) | (A.hi==B.hi & A.m2==B.m2 & A.m1==B.m1 & A.lo<=B.lo), tf=true; else, tf=false; end, end
        function tf=ge(A,B), if (A.hi>=B.hi) | (A.hi==B.hi & A.m2>=B.m2) | (A.hi==B.hi & A.m2==B.m2 & A.m1>=B.m1) | (A.hi==B.hi & A.m2==B.m2 & A.m1==B.m1 & A.lo>=B.lo), tf=true; else, tf=false; end, end
        function tf=ne(A,B), if (A.hi~=B.hi) | (A.m2~=B.m2) | (A.m1~=B.m1) | (A.lo~=B.lo), tf=true; else, tf=false; end, end
        function tf=eq(A,B), if (A.hi==B.hi) & (A.m2==B.m2) & (A.m1==B.m1) & (A.lo==B.lo), tf=true; else, tf=false; end, end
 
        function A = RR_bitsll(A,k)            
            A.hi=bitsll(A.hi,k); for i=1:k; A.hi=bitset(A.hi,i,bitget(A.m2,64-k+i)); end
            A.m2=bitsll(A.m2,k); for i=1:k; A.m2=bitset(A.m2,i,bitget(A.m1,64-k+i)); end
            A.m1=bitsll(A.m1,k); for i=1:k; A.m1=bitset(A.m1,i,bitget(A.lo,64-k+i)); end
            A.lo=bitsll(A.lo,k); 
        end
        function A = RR_bitsrl(A,k)            
            A.lo=bitsrl(A.lo,k); for i=1:k; A.lo=bitset(A.lo,64-k+i,bitget(A.m1,i)); end
            A.m1=bitsrl(A.m1,k); for i=1:k; A.m1=bitset(A.m1,64-k+i,bitget(A.m2,i)); end
            A.m2=bitsrl(A.m2,k); for i=1:k; A.m2=bitset(A.m2,64-k+i,bitget(A.hi,i)); end
            A.hi=bitsrl(A.hi,k); 
        end
    end
    methods(Access = protected)
        function displayScalarObject(OBJ)
            fprintf('RR_uint256 with {hi,m2,m1,lo} = {0x%s,0x%s,0x%s,0x%s}\n',dec2hex(OBJ.hi,16),dec2hex(OBJ.m2,16),dec2hex(OBJ.m1,16),dec2hex(OBJ.lo,16))
        end
    end
end 
