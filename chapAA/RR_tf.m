% classdef RR_tf
%
% This class defines a set of operations on transfer functions, each given by a pair of 
% numerator and denominator polynomials of the RR_Poly class.
% DEFINITION:
%   G=RR_tf(num,den)    defines an RR_tf object G from numerator and denominator polynomials
%   G=RR_tf(z,p,K)      defines an RR_tf object G from vectors of zeros and poles, z and p, and the gain K
%   Note that any RR_tf object G has two RR_Poly fields, G.num and G.den
% STANDARD OPERATIONS (overloading the +, -, *, ./, and ^ operators):
%   plus:     G1+G2  gives the sum of two transfer functions        (or, a transfer functions and a scalar)
%   minus:    G1-G2  gives the difference of two transfer functions (or, a transfer functions and a scalar)
%   mtimes:   G1*G2  gives the product of two transfer functions    (or, a transfer functions and a scalar)
%   rdivide:  T=G1./G2 divides two transfer functions
% SOME TESTS:  [Try them!!]
%   G=RR_tf([1 10],[1 100]), D=RR_tf([1 2],[4 5])          % Define a couple of test transfer functions
% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License.

classdef RR_tf < matlab.mixin.CustomDisplay
    properties
    	num
    	den
    end
    methods
    	function obj = RR_tf(a,b,c)
    		switch nargin
    			case 1  % 1 argument: define RR_tf object from polynomial a
    				if ~isa(a,'RR_Poly'), a=RR_Poly(a); end, obj = RR_tf(a,1);
    			case 2 	% 2 arguments: define RR_tf object from numerator a and denominator b
     				if  isa(a,'RR_Poly'), obj.num=a; else, obj.num=RR_Poly(a); end
   					if  isa(b,'RR_Poly'), obj.den=b; else, obj.den=RR_Poly(b); end
   					t=1/obj.den.poly(1); obj.den=obj.den*t; obj.num=obj.num*t;  % Make den monic
   				case 3	% 3 arguments: define RR_tf object from vectors of zeros and poles, a and b, and gain c
    	    		obj.num=c*RR_Poly(a,'roots'); obj.den=RR_Poly(b,'roots');
    	    end
     	    if obj.num.poly==0, obj.den=RR_Poly(1); end
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
    end
    methods(Access = protected)
        function displayScalarObject(obj)
            fprintf(getHeader(obj)),
            fprintf('num:'), disp(obj.num.poly)
            fprintf('den:'), disp(obj.den.poly)
            fprintf('  m: %d,  n: %d,  n_r: %d\n', obj.num.n, obj.den.n, obj.den.n-obj.num.n )
        end
    end
end