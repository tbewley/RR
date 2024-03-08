% classdef RR_uint64
% This class emulates uint64 with wrap on overflow, because unfortunately
% Matlab doesn't wrap (unlike C and Eminem).
% This emulation is inefficient - use of this code is recommended for pedagogical
% purposes only.  For production codes, you should absolutely use C instead.
%
% DEFINITION:
%   a=RR_uint64(c)  defines an RR_uint64 object from any positive integer
%
% STANDARD OPERATIONS defined on RR_poly objects (overloading the +, -, *, /, ^, <, >, <=, >=, ~=, == operators):
%   plus:     a+b  gives the sum of two integers
%   minus:    b-a  gives the difference of two integers
%   mtimes:   a*b  gives the product of two integers
%   mrdivide: [quo,rem]=b/a divides two integers, giving the quotient quo and remainder rem
%   mpower:   a^n  gives the n'th power of a polynomial
%   Note that the relations <, >, <=, >=, ~=, == are all based just on the order of the polynomials.
%
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/RR_chapAA
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

classdef RR_uint64 < matlab.mixin.CustomDisplay
    properties % Each RR_poly object consists of the just one field:
        v      % a uint64 value (note, however, that +,-,*,/ are redefined to wrap on overflow!)
    end
    methods
        function obj = RR_uint64(v)     % a=RR_uint64 creates an RR_uint64 object obj.
            if strcmp(class(v),'sym'), error('RR_uint64 only defined for numeric arguments'), end
            obj.v = uint64(abs(v));
            if sign(v)==-1, obj.v=bitcmp(obj.v)+1; end
        end
        function [sum,carry] = plus(a,b)               % Defines a+b
            [a,b]=check(a,b); c=uint64(9223372036854775807);
            sum=bitand(a.v,c) +bitand(b.v,c);   % add the first 63 bits
            MSB=bitget(a.v,64)+bitget(b.v,64)+bitget(sum,64);
            sum=RR_uint64(bitset(sum,64,bitget(MSB,1)));
            carry=bitget(MSB,2);
        end
        function diff = minus(a,b)        % Defines a-b
            diff=plus(a,-b);
        end    
        function prod = mtimes(a,b)       % Defines a*b
            [a,b]=check(a,b); cl=uint64(4294967295);
            al=bitand(a.v,cl); ah=bitsra(a.v,32); % {al,bl} are lower 32 bits of {a,b}
            bl=bitand(b.v,cl); bh=bitsra(b.v,32); % {ah,bh} are upper 32 bits of {a,b}
            prod=RR_uint64(bl*al)+RR_uint64(bitsll((al*bh)+(ah*bl),32));
        end
        function [quo,re] = mrdivide(b,a) % Defines [quo,re]=b/a
            [b,a]=check(b,a); quo=RR_uint64(idivide(b.v,a.v)); re=RR_uint64(rem(b.v,a.v));
        end
        function pow = mpower(a,n),  pow=RR_int(a.v^n); end                % Defines a^n
        function fac = factorial(a), fac=RR_int(factorial(a.v));  end      % Defines factorial(a)
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

% cheatsheet: bitwise operations on integers, in both C and Matlab
%  C  Bit Operations   Matlab
% ------------------------------
% a>>k  rightshift   bitsra(a,k)
% a<<k  leftshift    bitsll(a,k)
% a&b      AND       bitand(a,b)
% a^b      XOR       bitxor(a,b)
% a|b      OR        bitor(a,b)
% -a     2's comp.   bitcmp(a)
