% classdef RR_uint128
% This class emulates uint128 with wrap on overflow.
%
% DEFINITION:
%   a=RR_uint128(ch,cl)  defines an RR_uint64 object from two uint64 variables
%
% STANDARD OPERATIONS defined on RR_uint64 objects (overloading the +, -, *, /, ^, <, >, <=, >=, ~=, == operators):
%   plus:     a+b  gives the sum of two integers
%   minus:    b-a  gives the difference of two integers
%   mtimes:   a*b  gives the product of two integers
%   mrdivide: [quo,rem]=b/a divides two integers, giving the quotient quo and remainder rem
%   mpower:   a^n  gives the n'th power of the integer a
%   Note that the relations <, >, <=, >=, ~=, == are also defined.
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

classdef RR_uint128 < matlab.mixin.CustomDisplay
    properties % RR_uint128 objects consist of two fields, with +,-,*,/ defined to wrap on overflow
        h      % the high part of v, a uint64 value 
        l      % the low part of v,  a uint64 value
    end
    methods
        function obj = RR_uint128(a,b)  % create an RR_uint128 object obj.
            if nargin==1                % one argument: create {hi,lo} parts from {0,a}            
                 obj.h = uint64(0);
                 obj.l = uint64(a); 
            else                        % two arguments: create {hi,lo} parts from {a,b}
                 obj.h = uint64(a);
                 obj.l = uint64(b);
            end
        end
        function [sum] = plus(a,b)        % Defines a+b
            [h,l]=RR_sum128(a.h,a.l,b.h,b.l); sum=RR_uint128(h,l);
        end
        function diff = minus(a,b)        % Defines a-b
            bb=-b; [h,l]=RR_sum128(a.h,a.l,bb.h,bb.l); diff=RR_uint128(h,l);
        end
        function out = uminus(b)          % Defines (-b)
            [h,l]=RR_sum128(bitcmp(b.h),bitcmp(b.l),uint64(0),uint64(1)); out=RR_uint128(h,l);
        end    
        function prod = mtimes(a,b)       % Defines a*b
            [h,l]=RR_prod128(a.h,a.l,b.h,b.l); prod=RR_uint128(h,l);
        end
        function [quo,re] = mrdivide(b,a) % Defines [quo,re]=b/a
            [quo,re]=RR_div128(b,a)
        end
        function n = norm(a), n=abs(a.v); end                              % Defines norm(a)          
        % Now define a<b, a>b, a<=b, a>=b, a~=b, a==b based on the values of a and b.
        function TF=lt(a,b), if (a.h< b.h) | (a.h==b.h & a.l< b.l), TF=true; else, TF=false; end, end            
        function TF=gt(a,b), if (a.h> b.h) | (a.h==b.h & a.l> b.l), TF=true; else, TF=false; end, end
        function TF=le(a,b), if (a.h< b.h) | (a.h==b.h & a.l<=b.l), TF=true; else, TF=false; end, end
        function TF=ge(a,b), if (a.h> b.h) | (a.h==b.h & a.l>=b.l), TF=true; else, TF=false; end, end
        function TF=ne(a,b), if (a.v~=b.v) | (a.l~=b.l),            TF=true; else, TF=false; end, end
        function TF=eq(a,b), if (a.v==b.v) & (a.l==b.l),            TF=true; else, TF=false; end, end
 
        function a = RR_bitsll(a,k)            
            a.h=bitsll(a.h,k); for i=1:k; a.h=bitset(a.h,i,bitget(a.l,64-k+i)); end
            a.l=bitsll(a.l,k); 
        end
        function a = RR_bitsrl(a,k)            
            a.l=bitsrl(a.l,k); for i=1:k; a.l=bitset(a.l,64-k+i,bitget(a.h,i)); end
            a.h=bitsrl(a.h,k); 
        end



    end
    methods(Access = protected)
        function displayScalarObject(obj)
            fprintf('RR_uint128 with {h,l} = {0x%s,0x%s}\n',dec2hex(obj.h,16),dec2hex(obj.l,16))
        end
    end
end 

% cheatsheet: bitwise operations on unsigned integers, in both C and Matlab
%  C  Bit Operations   Matlab
% ------------------------------
% a>>k  rightshift   bitsrl(a,k)
% a<<k  leftshift    bitsll(a,k)
% a&b      AND       bitand(a,b)
% a^b      XOR       bitxor(a,b)
% a|b      OR        bitor(a,b)
% -a     2's comp.   bitcmp(a)
