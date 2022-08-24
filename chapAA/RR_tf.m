% classdef RR_tf
%
% This class defines a set of operations on transfer functions, each given by a pair of 
% numerator and denominator polynomials of the RR_poly class.
% DEFINITION:
%   G=RR_tf(num)      defines an RR_tf object G from a numerator polynomial, setting denominator=1
%   G=RR_tf(num,den)  2 arguments defines an RR_tf object from numerator and denominator polynomials
%   G=RR_tf(z,p,K)    3 arguments defines an RR_tf object from vectors of zeros and poles, z and p, and the gain K
%   Note that any RR_tf object G has two RR_poly fields, G.num and G.den
% STANDARD OPERATIONS (overloading the +, -, *, ./ operators):
%   plus:     G1+G2  gives the sum of two transfer functions        (or, a transfer functions and a scalar)
%   minus:    G1-G2  gives the difference of two transfer functions (or, a transfer functions and a scalar)
%   mtimes:   G1*G2  gives the product of two transfer functions    (or, a transfer functions and a scalar)
%   rdivide:  G1./G2 divides two transfer functions
% SOME TESTS:  [Try them! Change them!]
%   G=RR_tf([1.1 10 110],[1 10 100],1), D=RR_tf([1 2],[4 5])       % Define a couple of test transfer functions
%   T=G*D./(1+G*D)
% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License.

classdef RR_tf < matlab.mixin.CustomDisplay
    properties
    	num
    	den
        z
        p
        K
    end
    methods
    	function obj = RR_tf(a,b,c)
    		switch nargin
    			case 1  % 1 argument: define RR_tf object from polynomial a
    				if ~isa(a,'RR_poly'), a=RR_poly(a); end, obj = RR_tf(a,1);
    			case 2 	% 2 arguments: define RR_tf object from numerator a and denominator b
     				if  isa(a,'RR_poly'), obj.num=a; else, obj.num=RR_poly(a); end
   					if  isa(b,'RR_poly'), obj.den=b; else, obj.den=RR_poly(b); end
   					t=1/obj.den.poly(1); obj.den=obj.den*t; obj.num=obj.num*t;  % Make denominator monic
                    obj.z=roots(obj.num); obj.p=roots(obj.den); obj.K=obj.num.poly(1); 
   				case 3	% 3 arguments: define RR_tf object from vectors of zeros and poles, a and b, and gain c
                    obj.z=a; obj.p=b; obj.K=c;
    	    		obj.num=c*RR_poly(a,'roots'); obj.den=RR_poly(b,'roots');
    	    end
     	    if obj.num.poly==0, obj.den=RR_poly(1); end             % Simplify the zero transfer function
            if obj.num.n>0 & obj.den.n>0, for i=1:obj.num.n     
                j=find(abs(obj.z(i)-obj.p)<1e-8,1);
                if ~isempty(j); j=j(1); fprintf('Performing pole/zero cancellation at s=%f\n',obj.z(i))
                        obj.z=obj.z([1:i-1,i+1:obj.num.n]);
                        obj.p=obj.p([1:j-1,j+1:obj.den.n]); obj=RR_tf(obj.z,obj.p,obj.K); break, end
            end, end
    	end
    	function sum = plus(G1,G2)          % Defines G1+G2
            if ~isa(G1,'RR_tf'), G1=RR_tf(G1); end,  if ~isa(G2,'RR_tf'), G2=RR_tf(G2); end
            sum = RR_tf(G1.num*G2.den+G2.num*G1.den,G1.den*G2.den);
        end
        function diff = minus(G1,G2)        % Defines G1-G2
            if ~isa(G1,'RR_tf'), G1=RR_tf(G1); end,  if ~isa(G2,'RR_tf'), G2=RR_tf(G2); end
            diff = RR_tf(G1.num*G2.den-G2.num*G1.den,G1.den*G2.den);
        end    
        function prod = mtimes(G1,G2)       % Defines G1*G2
            if ~isa(G1,'RR_tf'), G1=RR_tf(G1); end,  if ~isa(G2,'RR_tf'), G2=RR_tf(G2); end
            prod = RR_tf(G1.num*G2.num,G1.den*G2.den);
        end
        function quo = rdivide(G1,G2)        % Defines G1/G2
            if ~isa(G1,'RR_tf'), G1=RR_tf(G1); end,  if ~isa(G2,'RR_tf'), G2=RR_tf(G2); end
            quo=RR_tf(G1.num*G2.den,G1.den*G2.num);
        end
    end
    methods(Access = protected)
        function displayScalarObject(obj)
            fprintf(getHeader(obj))
            fprintf('num:'), disp(obj.num.poly)
            fprintf('den:'), disp(obj.den.poly)
            fprintf('  m: %d,  n: %d,  n_r=n-m: %d,  K: %f\n', obj.num.n, obj.den.n, obj.den.n-obj.num.n, obj.K)
            fprintf('  z:'), disp(obj.z)
            fprintf('  p:'), disp(obj.p)
        end
    end
end