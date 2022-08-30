% classdef RR_int
%
% This class defines a set of operations over the integers, including Euclidian division
% DEFINITION:
%   a=RR_int(c)           defines an RR_ing object from an integer c
% STANDARD OPERATIONS (overloading the +, -, *, ./, and ^ operators):
%   plus:     a+b  gives the sum of two polynomials
%   minus:    b-a  gives the difference of two polynomials
%   mtimes:   a*b  gives the product of two polynomials
%   rdivide:  [quo,rem]=b./a divides two polynomials, giving the quotient quo and remainder rem
%   mpower:   a^n  gives the n'th power of a polynomial
% ADDITIONAL OPERATIONS:
%   n = norm(b,option)         Gives the norm of b.poly [see: "help norm" - option=2 if omitted]
%   r = roots(b)               Gives a vector of roots r from a RR_poly object b
%   z = eval(b,s)              Evaluates b(s) for some (real or complex) scalar s
%   d = diff(p,m)              Computes the m'th derivative of the polynomial p
% SOME TESTS:  [Try them! Change them!]
%   a=RR_poly([1 2 3]), b=RR_poly([1 2 3 4 5 6])          % Define a couple of test polynomials
%   sum=a+b, diff=b-a, product=a*b, q=b./a, [q,rem]=b./a  % (self explanatory)
%   check=(a*q+rem)-b, check_norm=norm(check)             % note: check should be the zero polynomial
%   r=[-3 -1 1 3], b=RR_poly(r,'roots'), r1=roots(b)      % note: r and r1 should match
%   check_norm=norm(sort(r)-r1)                           % norm should be zero
%   s1=0, z1=evaluate(b,s1), s2=3, z2=evaluate(b,s2)      % note: z1 should be nonzero, z2 should be zero
%   for m=0:d = diff(p,m)
% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License.

classdef RR_int < matlab.mixin.CustomDisplay
    properties  % Each RR_int object consists of a single value field:
        v
    end
    methods
        function obj  = RR_int(c),   obj.v=int32(c);                         end  % Defines RR_int object
        function sum  = plus(a,b),   [a,b]=check(a,b); sum =RR_int(a.v+b.v); end  % Defines a+b
        function diff = minus(a,b),  [a,b]=check(a,b); diff=RR_int(a.v-b.v); end  % Defines a-b
        function prod = mtimes(a,b), [a,b]=check(a,b); prod=RR_int(a.v*b.v); end  % Defines a*b
        function [quo,re] = rdivide(b,a)                                          % Defines [quo,rem]=b./a
            [b,a]=check(b,a); quo=RR_int(idivide(b.v,a.v)); re=RR_int(rem(b.v,a.v));
        end
        function pow = mpower(a,n),  pow=RR_int(a.val^n); end                     % Defines a^n
        % Now define a<b, a>b, a<=b, a>=b, a~=b, a==b based on the values of a and b.
        function TF=lt(a,b), if a.v< b.v, TF=true; else, TF=false; end, end            
        function TF=gt(a,b), if a.v> b.v, TF=true; else, TF=false; end, end
        function TF=le(a,b), if a.v<=b.v, TF=true; else, TF=false; end, end
        function TF=ge(a,b), if a.v>=b.v, TF=true; else, TF=false; end, end
        function TF=ne(a,b), if a.v~=b.v, TF=true; else, TF=false; end, end
        function TF=eq(a,b), if a.v==b.v, TF=true; else, TF=false; end, end
        function [a,b]=check(a,b)
            if ~isa(a,'RR_int'), a=RR_int(a); end,  if ~isa(b,'RR_int'), b=RR_int(b); end
        end
        function n = norm(a), n=abs(a.v); end
    end
    methods(Access = protected)
        function displayScalarObject(obj)
            fprintf(strcat(class(obj),' with value: ')),  disp(obj.v)
        end
    end
end



 