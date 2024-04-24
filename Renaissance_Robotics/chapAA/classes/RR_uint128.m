% classdef RR_uint128
% This class developes a uint128 type (built with two uint64 types) with wrap on overflow.
%
% Note that, as is standard, unsigned integer division and remainder are defined in RR such that
%   A = (A/B)*B + (A rem B) where (A rem B) has value less than the value of B.
% Unfortunately, as of April 2024, Matlab's built-in integer division,  A/B, doesn't conform to this
% standard, and thus should probably not be used when doing integer math, unless/until this is fixed.
% For example, taking the following in Matlab: [can also replace 64 with one of {8,16,32}]
%             b=uint64(7), a=uint64(4), q=b/a, r=rem(b,a)  gives  q=2, r=3.  (doah!)
% On the other hand, taking the following: [can also replace 64 with one of {8,16,32,128,256,512}]
%             B=RR_uint64(7), A=RR_uint64(4),  [Q,R]=B/A   gives  q=1, r=3.  :)
%
% DEFINITION:
%   A=RR_uint128(h,l) defines an RR_uint128 object from 2 uint64 variables, 0<=A<=2^128-1=3.40e+38
%
% STANDARD OPERATIONS defined on RR_uint128 objects
% (overloading the +, -, *, /, ^, <, >, <=, >=, ~=, == operators):
%   plus:     [sum,carry]=a+b  gives the sum of two RR_uint128 integers
%   uminus:   -a gives the two's complement representation of negative a
%   minus:    b-a  gives the difference of two RR_uint128 integers (in two's complement form if negative)
%   mtimes:   [sum,carry]=a*b  gives the product of two RR_uint128 integers
%   mrdivide: [quo,rem]=b/a divides two RR_uint128 integers, giving the quotient quo and remainder rem
%   The relations <, >, <=, >=, ~=, == are also clearly defined.
%   {+,-,*} are built on uint64 primatives; the nonrestoring division algorithm is used to compute a/b
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
            [sh,sl,c]=RR_sum128(A.h,A.l,B.h,B.l); SUM=RR_uint128(sh,sl); CARRY=RR_uint128(c);
        end
        function DIFF = minus(A,B)          % Defines a-b
            BB=-B; [h,l]=RR_sum128(A.h,A.l,BB.h,BB.l); DIFF=RR_uint128(h,l);
        end
        function out = uminus(b)            % Defines (-b)
            [h,l]=RR_sum128(bitcmp(b.h),bitcmp(b.l),uint64(0),uint64(1)); out=RR_uint128(h,l);
        end    
        function [PROD,CARRY] = mtimes(A,B) % Defines [PROD,CARRY]=a*b, ignore CARRY for wrap on overflow
            [ph,pl,ch,cl]=RR_prod128(A.h,A.l,B.h,B.l);
            PROD=RR_uint128(ph,pl); CARRY=RR_uint128(ch,cl);
        end
        function [QUO,RE] = mrdivide(B,A)   % Defines [QUO,RE]=B/A
            [QUO,RE]=RR_div128(B,A);
        end
        function n = norm(A), n=abs(A.v); end  % Defines norm(a)          
        % Now define a<b, a>b, a<=b, a>=b, a~=b, a==b based on the values of a and b.
        function tf=lt(A,B), if (A.h< B.h) | (A.h==B.h & A.l< B.l), tf=true; else, tf=false; end, end            
        function tf=gt(A,B), if (A.h> B.h) | (A.h==B.h & A.l> B.l), tf=true; else, tf=false; end, end
        function tf=le(A,B), if (A.h< B.h) | (A.h==B.h & A.l<=B.l), tf=true; else, tf=false; end, end
        function tf=ge(A,B), if (A.h> B.h) | (A.h==B.h & A.l>=B.l), tf=true; else, tf=false; end, end
        function tf=ne(A,B), if (A.v~=B.v) | (A.l~=B.l),            tf=true; else, tf=false; end, end
        function tf=eq(A,B), if (A.v==B.v) & (A.l==B.l),            tf=true; else, tf=false; end, end
 
        function A = RR_bitsll(A,k)            
            A.h=bitsll(A.h,k); for i=1:k; A.h=bitset(A.h,i,bitget(A.l,64-k+i)); end
            A.l=bitsll(A.l,k); 
        end
        function A = RR_bitsrl(A,k)            
            A.l=bitsrl(A.l,k); for i=1:k; A.l=bitset(A.l,64-k+i,bitget(A.h,i)); end
            A.h=bitsrl(A.h,k); 
        end
    end
    methods(Access = protected)
        function displayScalarObject(OBJ)
            fprintf('RR_uint128 with {h,l} = {0x%s,0x%s}\n',dec2hex(OBJ.h,16),dec2hex(OBJ.l,16))
        end
    end
end 

