% classdef RR_poly
%
% This class defines a set of operations on row vectors, each interpreted as the 
% coefficients of a polynomial, written in descending orrder.  For example,
% b=[1 2 0 4] in this class is interpreted as the polynomial b(s)=s^3+2*s^2+4.
% DEFINITION:
%   a=RR_poly(c)          defines an RR_poly object from a coefficient vector c
%   a=RR_poly(r,'roots')  defines an RR_poly object from a vector of roots r
%   Note that any RR_poly object b has two fields, b.poly and b.n
% STANDARD OPERATIONS (overloading the +, -, *, ./, ^, <, >, <=, >=, ~=, == operators):
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
% Copyright 2022 by Thomas Bewley and Muhan Zhou, distributed under BSD 3-Clause License.

classdef RR_poly < matlab.mixin.CustomDisplay
    properties  % Each RR_poly object consists of the following two fields:
        poly    % The polynomial coefficients themselves, just an ordinary row vector
        n       % The order of this polynomial.  Note that poly has n+1 elements
    end
    methods
        function obj = RR_poly(c,flag)       % a=RR_poly creates an RR_poly object obj.
            if nargin==1                     % one argument: create obj for c = vector of coefficients            
                 index=find(abs(c(1:end-1))>1e-10,1);     % First trim off any leading zeros!
                 if isempty(index), index=length(c); end 
                 obj.poly = c(index:end);
                 obj.n    = length(obj.poly)-1; 
            else                             % two arguments: create obj for c = vector of roots
                 obj=RR_poly([1]); index=1;  % note: flag can be anything!  recommend flag='roots'...  :)
                 for k=1:length(c), obj=obj*RR_poly([1 -c(k)]); end % (the resulting p in this case is monic)
            end 
        end
        function sum = plus(a,b)          % Defines a+b
            if ~isa(a,'RR_poly'), a=RR_poly(a); end,  if ~isa(b,'RR_poly'), b=RR_poly(b); end
            sum = RR_poly([zeros(1,b.n-a.n) a.poly]+[zeros(1,a.n-b.n) b.poly]);
        end
        function diff = minus(a,b)        % Defines a-b
            if ~isa(a,'RR_poly'), a=RR_poly(a); end,  if ~isa(b,'RR_poly'), b=RR_poly(b); end
            diff = RR_poly([zeros(1,b.n-a.n) a.poly]-[zeros(1,a.n-b.n) b.poly]);
        end    
        function prod = mtimes(a,b)       % Defines a*b
            if ~isa(a,'RR_poly'), a=RR_poly(a); end,  if ~isa(b,'RR_poly'), b=RR_poly(b); end
            p=zeros(1,b.n+a.n+1);
            for k=0:b.n; p=p+[zeros(1,b.n-k) b.poly(b.n+1-k)*a.poly zeros(1,k)]; end
            prod=RR_poly(p);
        end
        function [quo,rem] = rdivide(b,a) % Defines [quo,rem]=b./a
            if ~isa(a,'RR_poly'), a=RR_poly(a); end,  if ~isa(b,'RR_poly'), b=RR_poly(b); end
            bp=b.poly; ap=a.poly;          % <-- just a couple of shorthands to simplify notation
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
        % Define a<b, a>b, a<=b, a>=b, a~=b, a==b based on the orders of a and b.
        function TF=lt(a,b), if a.n< b.n, TF=true; else, TF=false; end, end
        function TF=gt(a,b), if a.n> b.n, TF=true; else, TF=false; end, end
        function TF=le(a,b), if a.n<=b.n, TF=true; else, TF=false; end, end
        function TF=ge(a,b), if a.n>=b.n, TF=true; else, TF=false; end, end
        function TF=ne(a,b), if a.n~=b.n, TF=true; else, TF=false; end, end
        function TF=eq(a,b), if a.n==b.n, TF=true; else, TF=false; end, end
        function n = norm(a,option)       % Defines n=norm(a,option), where a is an RR_poly object
            if nargin<2, option=2; end    % Second argument is optional [see "help norm"]
            n = norm(a.poly,option);
        end
        function r = roots(p)             % Defines r=roots(p), where p is an RR_poly object
            r=sort(roots(p.poly))';
        end
        function z = evaluate(a, s)
            z=0; for k=1:a.n+1; z=z+a.poly(k)*s^(a.n+1-k); end
        end
        function p = diff(p,m)            % Computes the m'th derivative of the polynomial p
            if nargin<2, m=1; end
            p.poly=[p.n:-1:1].*p.poly(1:p.n); p.n=length(p.poly)-1;
            if p.n<0, p=RR_poly(0); end
            if m>1, p=diff(p,m-1); end
        end
    end
    methods(Access = protected)
        function displayScalarObject(obj)
            fprintf(getHeader(obj)),
            fprintf('poly: '), disp(obj.poly)
            fprintf('roots:'), disp(sort(roots(obj.poly),'real')')
            fprintf('   n: %d\n',obj.n)
        end
    end
end
