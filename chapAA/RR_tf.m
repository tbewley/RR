% classdef RR_tf
%
% This class defines a set of operations on transfer functions, each given by a pair of 
% numerator and denominator polynomials of the RR_poly class, and the equivalent (z,p,K) representation.
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
%   G=RR_tf([1.1 10 110],[0 1 10 100],1), D=RR_tf([1 2],[4 5])       % Define a couple of test transfer functions
%   T=G*D./(1+G*D)
% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License.

classdef RR_tf < matlab.mixin.CustomDisplay
    properties
    	num  % num and den are of type RR_poly 
    	den
        z    % z and k are row vectors, and K is an ordinary scalar
        p
        K    % Note that the (num,den) and (z,p,K) representations of the transfer function are equivalent
    end
    methods
    	function obj = RR_tf(a,b,c)
            % Generate an RR_tf object:
            %   called with 1 argument,  generates from a numerator polynomial a
            %   called with 2 arguments, generates from a numerator polynomial a and a denominator polynomial b
            %   called with 3 arguments, generates from vectors of zeros and poles, a and b, and the overall gain c
    		switch nargin
    			case 1  
    				if ~isa(a,'RR_poly'), a=RR_poly(a); end, obj = RR_tf(a,1);
    			case 2 	
     				if  isa(a,'RR_poly'), obj.num=a; else, obj.num=RR_poly(a); end
   					if  isa(b,'RR_poly'), obj.den=b; else, obj.den=RR_poly(b); end
   					t=1/obj.den.poly(1); obj.den=obj.den*t; obj.num=obj.num*t;  % Make denominator monic
                    obj.z=roots(obj.num); obj.p=roots(obj.den); obj.K=obj.num.poly(1); 
   				case 3	
                    obj.z=a; obj.p=b; obj.K=c;
    	    		obj.num=c*RR_poly(a,'roots'); obj.den=RR_poly(b,'roots');
    	    end
     	    if obj.num.poly==0, obj.den=RR_poly(1); fprintf('Simplifying the zero transfer function\n'), end 
            if obj.num.n>0 & obj.den.n>0, for i=1:obj.num.n     
                j=find(abs(obj.z(i)-obj.p)<1e-8,1);
                if ~isempty(j); j=j(1); fprintf('Performing pole/zero cancellation at s=%f\n',obj.z(i))
                        obj.z=obj.z([1:i-1,i+1:obj.num.n]);
                        obj.p=obj.p([1:j-1,j+1:obj.den.n]); obj=RR_tf(obj.z,obj.p,obj.K); break, end
            end, end
    	end
    	function sum = plus(G1,G2)          
            % Defines G1+G2, where G1 and/or G2 are of class RR_tf
            % If G1 or G2 is a scalar, vector, or of class RR_poly, it is first converted to class RR_tf   
            [G1,G2]=check(G1,G2); sum  = RR_tf(G1.num*G2.den+G2.num*G1.den,G1.den*G2.den);
        end
        function diff = minus(G1,G2)       
            % Defines G1-G2, where G1 and/or G2 are of class RR_tf
            % If G1 or G2 is a scalar, vector, or of class RR_poly, it is first converted to class RR_tf   
            [G1,G2]=check(G1,G2); diff = RR_tf(G1.num*G2.den-G2.num*G1.den,G1.den*G2.den);
        end    
        function prod = mtimes(G1,G2)       
            % Defines G1*G2, where G1 and/or G2 are of class RR_tf
            % If G1 or G2 is a scalar, vector, or of class RR_poly, it is first converted to class RR_tf   
            [G1,G2]=check(G1,G2); prod = RR_tf(G1.num*G2.num,G1.den*G2.den);
        end
        function quo = rdivide(G1,G2)
            % Defines G1/G2, where G1 and/or G2 are of class RR_tf
            % If G1 or G2 is a scalar, vector, or of class RR_poly, it is first converted to class RR_tf   
            [G1,G2]=check(G1,G2); quo  = RR_tf(G1.num*G2.den,G1.den*G2.num);
        end
        function [G1,G2]=check(G1,G2)
            % Converts G1 or G2, as necessary, to class RR_tf
            if ~isa(G1,'RR_tf'), G1=RR_tf(G1); end,  if ~isa(G2,'RR_tf'), G2=RR_tf(G2); end
        end
        function [p,d,k,n]=PartialFractionExpansion(F,eps)
            % Compute {p,d,k,n} so that F(s)=num(s)/den(s)=d(1)/(s-p(1))^k(1) +...+ d(n)/(s-p(n))^k(n)
            % INPUTS:  F   a proper rational polynomial of class RR_tf with m<n and n>0, where m=F.num.n and n=F.den.n
            %          eps tolerance used when calculating repeated roots
            % OUTPUTS: p   poles of F (a row vector of length n)
            %          d   coefficients of the partial fraction expansion (a row vector of length n)
            %          k   powers of the denominator in each term (a row vector of length n)
            %          n   number of terms in the expansion
            % TEST:    [p,d,k,n] = PartialFractionExpansion(RR_tf([1000 1000],[1 100 1000 1000 0]))
            % Renaissance Robotics codebase, Appendix A (derivation in Appendix B), https://github.com/tbewley/RR
            % Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License.
            m=F.num.n; n=F.den.n;
            if m==n, flag=1; [div,rem]=F.num/F.den; m=m-1; else, flag=0; rem=F.num; end
            k=ones(1,n); p=F.p; if nargin<2, eps=1e-3; end
            for i=1:n-1, if abs(p(i+1)-p(i))<eps, k(i+1)=k(i)+1; end, end, k(n+1)=0;
            for i=n:-1:1
                if k(1,i)>=k(i+1), r=k(i); a=RR_poly(1);
                    for j=1:i-k(i),    a=a*[1 -p(j)]; end
                    for j=i+1:n,       a=a*[1 -p(j)]; end
                    for j=1:k(i)-1,    ad{j}=diff(a,j); end
                end
                q=r-k(i); d(i)=evaluate(diff(rem,q),p(i))/RR_Factorial(q);
                for j=q:-1:1, d(i)=d(i)-d(i+j)*evaluate(ad{j},p(i))/RR_Factorial(j); end
                d(i)=d(i)/evaluate(a,p(i));
            end, if ~flag, k=k(1:n); else, n=n+1; p(n,1)=1; d(n,1)=div; end
        end 
    end
    methods(Access = protected)
        function displayScalarObject(obj)
            fprintf(getHeader(obj))
            fprintf('num:'), disp(obj.num.poly)
            fprintf('den:'), disp(obj.den.poly)
            nr=obj.den.n-obj.num.n;
            if nr>0, s='strictly proper'; elseif nr==0, s='semiproper'; else, s='improper'; end
            fprintf('  m=%d, n=%d, n_r=n-m=%d, %s, K=%f\n', obj.num.n, obj.den.n, nr, s, obj.K)
            fprintf('  z:'), disp(obj.z)
            fprintf('  p:'), disp(obj.p)
        end
    end
end


% .ooo.
% .o...
% ....x
% oo..x
% oxx.x
% oxx.x

% .ooo.
% ...o.
% x....
% x..oo
% x.xxo
% x.xxo




