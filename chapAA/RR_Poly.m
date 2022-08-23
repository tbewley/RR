% classdef RR_Poly
%
% This class defines a set of operations on row vectors, each interpreted as the 
% coefficients of a polynomial, written in descending orrder.  For example,
% b=[1 2 0 4] in this class is interpreted as the polynomial b(s)=s^3+2*s^2+4.
% DEFINITION:
%   a=RR_Poly(c)          defines an RR_Poly object from a coefficient vector c
%   a=RR_Poly(r,'roots')  defines an RR_Poly object from a vector of roots r
%   Note that any RR_Poly object b has two fields, b.poly and b.n
% STANDARD OPERATIONS (overloading the +, -, *, and ./ operators):
%   plus:     a+b  gives the sum of two polynomials.
%   minus:    b-a  gives the difference of two polynomials.
%   mtimes:   a*b  gives the product of two polynomials.
%   rdivide:  [quo,rem]=b./a divides two polynomials, giving the quotient quo and remainder rem
% ADDITIONAL OPERATIONS:
%   n = norm(b,option)         Gives the norm of b.poly [see: "help norm" - option=2 if omitted]
%   r = roots(b)               Gives a vector of roots r from a RR_Poly object b
%   z = eval(b,s)              Evaluates b(s) for some (real or complex) scalar s
% SOME TESTS:  [Try them!!]
%   a=RR_Poly([1 2 3]), b=RR_Poly([1 2 3 4 5 6])          % Define a couple of test polynomials
%   sum=a+b, diff=b-a, product=a*b, q=b./a, [q,rem]=b./a  % (self explanatory)
%   check=(a*q+rem)-b, check_norm=norm(check)             % note: check should be the zero polynomial
%   r=[-3 -1 1 3], b=RR_Poly(r,'roots'), r1=roots(b)      % note: r and r1 should match (change r!)
%   check_norm=norm(sort(r)-r1)                           % norm should be zero
%   s1=0, z1=evaluate(b,s1), s2=3, z2=evaluate(b,s2)      % note: z1 should be nonzero, z2 should be zero
% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley and Muhan Zhou, distributed under BSD 3-Clause License.

classdef RR_Poly
    properties  % Each RR_Poly object consists of the following two fields:
        poly    % The polynomial coefficients themselves, just an ordinary row vector
        n       % The order of this polynomial.  Note that poly has n+1 elements
    end
    methods
        function obj = RR_Poly(c,flag)       % a=RR_Poly creates an RR_Poly object obj.
            if nargin==1                     % one argument: create obj for c = vector of coefficients            
                 index=find(abs(c(1:end-1))>1e-10,1);     % First trim off any leading zeros!
                 if isempty(index), index=length(c); end 
                 obj.poly = c(index:end);
                 obj.n    = length(obj.poly)-1; 
            else                             % two arguments: create obj for c = vector of roots
                 obj=RR_Poly([1]); index=1;  % note: flag can be anything!  recommend flag='roots'...  :)
                 for k=1:length(c), obj=obj*RR_Poly([1 -c(k)]); end % (the resulting p in this case is monic)
            end 
        end
        function sum = plus(a,b)          % Defines a+b
            sum = RR_Poly([zeros(1,b.n-a.n) a.poly]+[zeros(1,a.n-b.n) b.poly]);
        end
        function diff = minus(a,b)        % Defines a-b
            diff = RR_Poly([zeros(1,b.n-a.n) a.poly]-[zeros(1,a.n-b.n) b.poly]);
        end    
        function prod = mtimes(a,b)       % Defines a*b
            p=zeros(1,b.n+a.n+1);
            for k=0:b.n; p=p+[zeros(1,b.n-k) b.poly(b.n+1-k)*a.poly zeros(1,k)]; end
            prod=RR_Poly(p);
        end
        function [quo,rem] = rdivide(b,a) % Defines b./a
            bp=b.poly, ap=a.poly          % <-- just a couple of shorthands to simplify notation
            if b.n<a.n, dp=0; else
              if strcmp(class(bp),'sym')|strcmp(class(ap),'sym'), syms dp, end
              for j=1:b.n-a.n+1
                dp(j)=bp(1)/ap(1); bp(1:a.n+1)=bp(1:a.n+1)-dp(j)*ap; bp=bp(2:end);
              end
            end
            quo=RR_Poly(dp); rem=RR_Poly(bp); 
        end
        function n = norm(a,option)       % Defines n=norm(a,option), where a is an RR_Poly object
            if nargin<2, option=2; end    % Second argument is optional [see "help norm"]
            n = norm(a.poly,option);
        end
        function r = roots(p)             % Defines r=roots(p), where p is an RR_Poly object
            r=sort(roots(p.poly))';
        end
        function z = evaluate(a, s)
            z=0; for k=1:a.n+1; z=z+a.poly(k)*s^(a.n+1-k); end
        end
    end
end