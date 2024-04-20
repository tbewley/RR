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
        vh     % the high part of v, a uint64 value 
        vl     % the low part of v,  a uint64 value
    end
    methods
        function obj = RR_uint64(vh,vl)    % a=RR_uint64 creates an RR_uint64 object obj.
            obj.vh = uint64(abs(vh));
            obj.vl = uint64(abs(vl));
        end
        function [sum,carry] = plus(a,b)  % Defines a+b
            [a,b]=check(a,b);
            sum=bitand(a.v,0x7FFFFFFFFFFFFFFF)+bitand(b.v,0x7FFFFFFFFFFFFFFF); % add first 63 bits
            MSB=bitget(a.v,64)+bitget(b.v,64)+bitget(sum,64);
            sum=RR_uint64(bitset(sum,64,bitget(MSB,1)));
            carry=bitget(MSB,2);
        end
        function diff = minus(a,b)        % Defines a-b
            [a,b]=check(a,b);
            diff=a+(-b);
        end
        function out = uminus(a)
            out=RR_uint64(bitcmp(a.v)+1);
        end    
        function prod = mtimes(a,b)       % Defines a*b
            [a,b]=check(a,b);
            al=bitand(a.v,0xFFFFFFFFu64); ah=bitsra(a.v,32); % {al,bl} are lower 32 bits of {a,b}
            bl=bitand(b.v,0xFFFFFFFFu64); bh=bitsra(b.v,32); % {ah,bh} are upper 32 bits of {a,b}
            prod=RR_uint64(bl*al)+RR_uint64(bitsll((al*bh)+(ah*bl),32));
        end
        function [quo,re] = mrdivide(b,a) % Defines [quo,re]=b/a
            [b,a]=check(b,a); quo=RR_uint64(idivide(b.v,a.v)); re=RR_uint64(rem(b.v,a.v));
        end
        function pow = mpower(a,n),  pow=RR_uint64(a.v^n); end             % Defines a^n
        function fac = factorial(a), fac=RR_uint64(factorial(a.v));  end   % Defines factorial(a)
        function n = norm(a), n=abs(a.v); end                              % Defines norm(a)          
        % Now define a<b, a>b, a<=b, a>=b, a~=b, a==b based on the values of a and b.
        function TF=lt(a,b), [a,b]=check(a,b); if a.v< b.v, TF=true; else, TF=false; end, end            
        function TF=gt(a,b), [a,b]=check(a,b); if a.v> b.v, TF=true; else, TF=false; end, end
        function TF=le(a,b), [a,b]=check(a,b); if a.v<=b.v, TF=true; else, TF=false; end, end
        function TF=ge(a,b), [a,b]=check(a,b); if a.v>=b.v, TF=true; else, TF=false; end, end
        function TF=ne(a,b), [a,b]=check(a,b); if a.v~=b.v, TF=true; else, TF=false; end, end
        function TF=eq(a,b), [a,b]=check(a,b); if a.v==b.v, TF=true; else, TF=false; end, end
        function [a,b]=check(a,b)
            if ~isa(a,'RR_uint64'), a=RR_uint64(a); end
            if ~isa(b,'RR_uint64'), b=RR_uint64(b); end
        end

    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods(Access = protected)
        function displayScalarObject(obj)
            fprintf(getHeader(obj))
            disp(obj.v)
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
