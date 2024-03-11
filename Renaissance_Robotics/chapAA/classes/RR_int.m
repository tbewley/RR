% classdef RR_int
% This class defines an integer ring, and a set of operations over it, including Euclidian division
% DEFINITION:
%   a=RR_int(c)           defines an RR_int object from an integer c
% STANDARD OPERATIONS (overloading the +, -, *, /, and ^ operators):
%   plus:     a+b  gives the sum of two integers
%   minus:    b-a  gives the difference of two integers
%   mtimes:   a*b  gives the product of two integers
%   mrdivide: [quo,rem]=b/a divides two integers, giving the quotient quo and remainder rem
%   mpower:   a^n  gives the n'th power of an integer
% ADDITIONAL OPERATIONS:
%   n = norm(b,option)         Gives the norm of b.v [see: "help norm" - option=2 if omitted]
% SOME TESTS:  [Try them! Change them!]
%   a=RR_int(3), b=RR_int(14)                             % Define a couple of test integers
%   sum=a+b, diff=b-a, product=a*b, q=b/a, [q,rem]=b/a    % (self explanatory)
%   check=(a*q+rem)-b, check_norm=norm(check)             % note: check should be zero
%   a^3                                                   % (self explanatory)
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 
% See also RR_poly, RR_tf.

classdef RR_int < matlab.mixin.CustomDisplay
    properties  % Each RR_int object consists of a single value field:
        v
    end
    methods
        function obj  = RR_int(c),   obj.v=int32(c);                         end  % Defines RR_int object
        function sum  = plus(a,b),   [a,b]=check(a,b); sum =RR_int(a.v+b.v); end  % Defines a+b
        function diff = minus(a,b),  [a,b]=check(a,b); diff=RR_int(a.v-b.v); end  % Defines a-b
        function prod = mtimes(a,b), [a,b]=check(a,b); prod=RR_int(a.v*b.v); end  % Defines a*b
        function [quo,re] = mrdivide(b,a)                                         % Defines [quo,rem]=b/a
            [b,a]=check(b,a); quo=RR_int(idivide(b.v,a.v)); re=RR_int(rem(b.v,a.v));
        end
        function pow = mpower(a,n),  pow=RR_int(a.v^n); end                       % Defines a^n
        function fac = factorial(a), fac=RR_int(factorial(a.v));  end             % Defines factorial(a)
        function n = norm(a), n=abs(a.v); end                                     % Defines norm(a)          
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
    end
    methods(Access = protected)
        function displayScalarObject(obj)
            fprintf(strcat(class(obj),' with value: ')),  disp(obj.v)
        end
    end
end



 