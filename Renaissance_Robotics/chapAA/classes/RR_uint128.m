% classdef RR_uint128
% A 128-bit unsigned integer class, built from two uint64 primatives, with wrap on overflow/underflow
% using two's complement notation.  Thus the following behavior (unlike Matlab's built-in functions):
%   A=RR_rand_RR_uint(128), B=-A, C=A+B  % gives C=0 [can replace 128 with anything from 1 to 1024...]
%
% RR defines unsigned integer division and remainder (unlike Matlab's built-in / operator)
% such that  B = (B/A)*A + R where the remainder R has value less than the value of B.  
% Thus the following behavior:
%   B=RR_rand_RR_uint(128), A=RR_rand_RR_uint(90)+1, [Q,R]=B/A, C=(Q*A+R)-B   % gives C=0.
%
% DEFINITION:
%   A=RR_uint128(h,l) defines an RR_uint128 object A from 2 uint64 variables, 0<=A<=2^128-1=3.40e+38
%
% STANDARD OPERATIONS defined on RR_uint128 objects
% (overloading the +, -, *, /, ^, <, >, <=, >=, ~=, == operators):
%   plus:     [SUM,CARRY]=A+B  gives the sum of two RR_uint128 integers (ignore CARRY for wrap)
%   uminus:   -A gives the two's complement representation of negative A (unlike built-in Matlab division)
%   minus:    B-A  gives the difference of two RR_uint128 integers (in two's complement form if negative)
%   mtimes:   [SUM,CARRY]=A*B  gives the product of two RR_uint128 integers (ignore CARRY for wrap)
%   mrdivide: [QUO,REM]=B/A divides two RR_uint128 integers, giving the quotient QUO and remainder REM
%   The relations <, >, <=, >=, ~=, == are also clearly defined.
%   {+,-,*} are built on uint64 primatives; the nonrestoring division algorithm is used to compute B/A.
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

classdef RR_uint128 < matlab.mixin.CustomDisplay
    properties % RR_uint128 objects OBJ consist of two fields, with +,-,*,/ defined to wrap on overflow
        h      % the high part of OBJ, a uint64 value 
        l      % the low  part of OBJ, a uint64 value
    end
    methods
        function OBJ = RR_uint128(a,b)  % create an RR_uint128 object obj from 1 or 2 uint64 inputs
            if nargin==1                % one argument: create {hi,lo} parts from {0,a}            
                OBJ.h=uint64(0); OBJ.l=uint64(a); 
            else                        % two arguments: create {hi,lo} parts from {a,b}
                OBJ.h=uint64(a); OBJ.l=uint64(b);
            end
        end
        function [SUM,CARRY] = plus(A,B)    % Defines [SUM,CARRY]=A+B, ignore CARRY for wrap on overflow
            A=RR_uint128.check(A); B=RR_uint128.check(B);
            [sh,sl,c]=RR_sum128(A.h,A.l,B.h,B.l); SUM=RR_uint128(sh,sl); CARRY=RR_uint128(c);
        end
        function DIFF = minus(A,B)          % Defines A-B
            A=RR_uint128.check(A); B=RR_uint128.check(B);
            BB=-B; [h,l]=RR_sum128(A.h,A.l,BB.h,BB.l); DIFF=RR_uint128(h,l);
        end
        function OUT = uminus(B)            % Defines (-B)
            B=RR_uint128.check(B);
            [h,l]=RR_sum128(bitcmp(B.h),bitcmp(B.l),uint64(0),uint64(1)); OUT=RR_uint128(h,l);
        end    
        function [PROD,CARRY] = mtimes(A,B) % Defines [PROD,CARRY]=a*b, ignore CARRY for wrap on overflow
            A=RR_uint128.check(A); B=RR_uint128.check(B);
            [ph,pl,ch,cl]=RR_prod128(A.h,A.l,B.h,B.l);
            PROD=RR_uint128(ph,pl); CARRY=RR_uint128(ch,cl);
        end
        function [QUO,RE] = mrdivide(B,A)   % Defines [QUO,RE]=B/A
            A=RR_uint128.check(A); B=RR_uint128.check(B); [QUO,RE]=RR_div128(B,A);
        end
        function n = norm(A), n=abs(A.v); end  % Defines norm(a)          
        % Now define a<b, a>b, a<=b, a>=b, a~=b, a==b based on the values of a and b.
        function tf=lt(A,B), A=RR_uint128.check(A); B=RR_uint128.check(B);
                             if (A.h< B.h) | (A.h==B.h & A.l< B.l), tf=true; else, tf=false; end, end            
        function tf=gt(A,B), A=RR_uint128.check(A); B=RR_uint128.check(B);
                             if (A.h> B.h) | (A.h==B.h & A.l> B.l), tf=true; else, tf=false; end, end
        function tf=le(A,B), A=RR_uint128.check(A); B=RR_uint128.check(B);
                             if (A.h< B.h) | (A.h==B.h & A.l<=B.l), tf=true; else, tf=false; end, end
        function tf=ge(A,B), A=RR_uint128.check(A); B=RR_uint128.check(B);
                             if (A.h> B.h) | (A.h==B.h & A.l>=B.l), tf=true; else, tf=false; end, end
        function tf=ne(A,B), A=RR_uint128.check(A); B=RR_uint128.check(B);
                             if (A.v~=B.v) | (A.l~=B.l),            tf=true; else, tf=false; end, end
        function tf=eq(A,B), A=RR_uint128.check(A); B=RR_uint128.check(B);
                             if (A.v==B.v) & (A.l==B.l),            tf=true; else, tf=false; end, end
        function s=sign(A),  if A.v==0,                             s=0;     else, s=1;      end, end 
        function A = RR_bitsll(A,k)            
            if k>63, A.h=A.l; A.l=uint64(0); k=k-64; end
            A.h=bitsll(A.h,k); for i=1:k; A.h=bitset(A.h,i,bitget(A.l,64-k+i)); end
            A.l=bitsll(A.l,k); 
        end
        function A = RR_bitsrl(A,k)
            if k>63, A.l=A.h; A.h=uint64(0); k=k-64; end               
            A.l=bitsrl(A.l,k); for i=1:k; A.l=bitset(A.l,64-k+i,bitget(A.h,i)); end
            A.h=bitsrl(A.h,k); 
        end
        function X=RR_128_to_256(XH,XL)
            if ~isa(XH,'RR_uint128'), XH=RR_uint128(XH); end
            if ~isa(XL,'RR_uint128'), XL=RR_uint128(XL); end                
            X=RR_uint256(XH.h,XH.l,XL.h,XL.l);
        end
    end
    methods(Static)
        function A=check(A)
            if isa(A,'numeric'), A=RR_uint128(A);
            elseif ~isa(A,'RR_uint128'), A=RR_uint128(A.v); end
        end
    end
    methods(Access = protected)
        function displayScalarObject(OBJ)
            fprintf('RR_uint128 with {h,l} = {0x%s,0x%s}\n',dec2hex(OBJ.h,16),dec2hex(OBJ.l,16))
        end
    end
end 

