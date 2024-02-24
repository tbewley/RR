% classdef RR_uint64
% This class emulates uint64 with wrap on overflow, because unfortunately Matlab doesn't
% normally provide it (unlike C).  It is built from any positive integer.
%
% DEFINITION:
%   a=RR_uint64(c)  defines an RR_uint64 object from any positive integer
%
% STANDARD OPERATIONS defined on RR_poly objects (overloading the +, -, *, /, ^, <, >, <=, >=, ~=, == operators):
%   plus:     a+b  gives the sum of two polynomials
%   minus:    b-a  gives the difference of two polynomials
%   mtimes:   a*b  gives the product of two polynomials
%   mrdivide: [quo,rem]=b/a divides two polynomials, giving the quotient quo and remainder rem
%   mpower:   a^n  gives the n'th power of a polynomial
%   Note that the relations <, >, <=, >=, ~=, == are all based just on the order of the polynomials.
%
% ADDITIONAL OPERATIONS defined on RR_poly objects: (try "help RR_poly/RR_*" for more info on any of them)
%   n = norm(b,option)       Gives the norm of b.poly [see: "help norm" - option=2 if omitted]
%   r = RR_roots(b)          Gives a vector of roots r from a RR_poly object b
%   z = RR_evaluate(b,s)     Evaluates b(s) for some (real or complex) scalar s
%   d = RR_derivative(p,m)   Computes the m'th derivative of the polynomial p
% 
% SOME TESTS:  [Try them! Change them!]
%   clear, a=RR_poly([1 2 3]), b=RR_poly([1 2 3 4 5 6])   % Define a couple of test polynomials
%   sum=a+b, diff=b-a, product=a*b, q=b/a, [q,rem]=b/a    % (self explanatory)
%   check=(a*q+rem)-b, check_norm=norm(check)             % note: check should be the zero polynomial
%
%% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
%% Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License. 

classdef RR_uint64 < matlab.mixin.CustomDisplay
    properties % Each RR_poly object consists of the just one field:
        v      % a uint64 value (note, however, that +,-,*,/ are redefined to wrap on overflow!)
    end
    methods
        function obj = RR_uint64(v)     % a=RR_uint64 creates an RR_uint64 object obj.
            if strcmp(class(v),'sym')), error('RR_uint64 only defined for numeric arguments'), end
            obj.v = uint64(abs(v));
            if sign(v)==-1, 
        end
        function sum = plus(a,b)          % Defines a+b
            sum.l = a.l+b.l % add the first 63 bits)
        end
        function diff = minus(a,b)        % Defines a-b
            [a,b]=check(a,b); diff=RR_poly([zeros(1,b.n-a.n) a.poly]-[zeros(1,a.n-b.n) b.poly]);
        end    
        function prod = mtimes(a,b)       % Defines a*b
            [a,b]=check(a,b); p=zeros(1,b.n+a.n+1);
            for k=0:b.n; p=p+[zeros(1,b.n-k) b.poly(b.n+1-k)*a.poly zeros(1,k)]; end
            prod=RR_poly(p);
        end
        function [quo,rem] = mrdivide(b,a) % Defines [quo,rem]=b/a
            [a,b]=check(a,b); bp=b.poly; ap=a.poly;  % <-- a couple of shorthands to simplify notation
            if b.n<a.n, dp=0; elseif a.n==0, dp=bp/ap; bp=0; else,
              if strcmp(class(bp),'sym')|strcmp(class(ap),'sym'), syms dp, end
              for j=1:b.n-a.n+1
                dp(j)=bp(1)/ap(1); bp(1:a.n+1)=bp(1:a.n+1)-dp(j)*ap; bp=bp(2:end);
              end
            end
            quo=RR_poly(dp); rem=RR_poly(bp); 
        end
        function pow = mpower(a,n)        % Defines a^n
             if n==0, pow=RR_poly([1]); else, pow=a; for i=2:n, pow=pow*a; end, end
        end
        % Define a<b, a>b, a<=b, a>=b, a~=b, a==b based simply on the orders of a and b.
        function TF=lt(a,b), if a.n< b.n, TF=true; else, TF=false; end, end
        function TF=gt(a,b), if a.n> b.n, TF=true; else, TF=false; end, end
        function TF=le(a,b), if a.n<=b.n, TF=true; else, TF=false; end, end
        function TF=ge(a,b), if a.n>=b.n, TF=true; else, TF=false; end, end
        function TF=ne(a,b), if a.n~=b.n, TF=true; else, TF=false; end, end
        function TF=eq(a,b), if a.n==b.n, TF=true; else, TF=false; end, end

        function [a,b]=check(a,b)
        % function [a,b]=check(a,b)
        % Converts a or b, as necessary, to the class RR_poly
        % NOTE: this routine is just used internally in this class definition.
        % Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
        % Copyright 2024 by Thomas Bewley, distributed under BSD 3-Clause License. 
            if ~isa(a,'RR_poly'), a=RR_poly(a); end,  if ~isa(b,'RR_poly'), b=RR_poly(b); end
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods(Access = protected)
        function displayScalarObject(obj)
            fprintf(getHeader(obj)),
            disp(v)
        end
    end
end
