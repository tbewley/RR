% classdef RR_poly
% This class defines a polynomial ring, and a set of operations over it, including Euclidian division.
% Each polynomial is defined as a row vector with integer, real, or complex entries, each interpreted
% as the coefficients of the polynomial, written in descending order.  For example,
% b=[1 2 0 4] in this class is interpreted as the polynomial b(s)=s^3+2*s^2+4.
% DEFINITION:
%   a=RR_poly(c)    defines an RR_poly object from a coefficient vector c
%   a=RR_poly(r,K)  defines an RR_poly object from a vector of roots r and gain K
%   syms a3 a2 a1 a0; a=RR_poly([a3 a2 a1 a0]) defines an RR_poly object from a vector of symbolic coefficients
%   Note that any RR_poly object b has three fields, b.poly, b.n, and b.s
% STANDARD OPERATIONS (overloading the +, -, *, ./, ^, <, >, <=, >=, ~=, == operators):
%   plus:     a+b  gives the sum of two polynomials
%   minus:    b-a  gives the difference of two polynomials
%   mtimes:   a*b  gives the product of two polynomials
%   rdivide:  [quo,rem]=b./a divides two polynomials, giving the quotient quo and remainder rem
%   mpower:   a^n  gives the n'th power of a polynomial
%   Note that the relations <, >, <=, >=, ~=, == are based just on the order of the polynomials.
% ADDITIONAL OPERATIONS:
%   n = norm(b,option)         Gives the norm of b.poly [see: "help norm" - option=2 if omitted]
%   r = roots(b)               Gives a vector of roots r from a RR_poly object b
%   z = eval(b,s)              Evaluates b(s) for some (real or complex) scalar s
%   d = diff(p,m)              Computes the m'th derivative of the polynomial p
% SOME TESTS:  [Try them! Change them!]
%   clear, a=RR_poly([1 2 3]), b=RR_poly([1 2 3 4 5 6])   % Define a couple of test polynomials
%   sum=a+b, diff=b-a, product=a*b, q=b./a, [q,rem]=b./a  % (self explanatory)
%   check=(a*q+rem)-b, check_norm=norm(check)             % note: check should be the zero polynomial
%
%   fprintf('\nBuild and test a polynomial b from its roots\n')
%   r=[-3 -1 1 3], b=RR_poly(r,5), s=roots(b), check=norm(sort(r)-s) % r and s should match, check should be zero
%   s1=0, z1=evaluate(b,s1), s2=3, z2=evaluate(b,s2)                 % z1 should be nonzero, z2 should be zero
%
%   fprintf('\nCompute and plot 5 derivatives of b\n')
%   fprintf('   b      = '), disp(b.poly)                 
%   for m=1:5; d=derivative(b,m); fprintf('d^%db/ds^%d = ',m,m), disp(d.poly), end
%
%   fprintf('\nCompute the inertia of unstable, marginally stable, and stable CT systems using Routh test\n')
%   a=RR_poly([-2.3 -1.7  1  i   -i  ],1), inertia=routh(a) % unstable
%   a=RR_poly([-2.3 -1.7 -1  i   -i  ],1), inertia=routh(a) % marginally stable
%   a=RR_poly([-2.3 -1.7 -1 -1+i -1-i],1), inertia=routh(a) % stable
%
%   fprintf('\nCompute the stationarity of unstable, marginally stable, and stable DT systems using Bistritz test\n')
%   a=RR_poly([-0.99 -.1+i -.1-i 5],1),        abs(roots(a)), stationarity=bistritz(a) % unstable
%   a=RR_poly([-0.99   i   -i 1],1),           abs(roots(a)), stationarity=bistritz(a) % marginally stable
%   a=RR_poly([-0.99 -.1+.9*i -.1-.9*i .5],1), abs(roots(a)), stationarity=bistritz(a) % stable
%
%   fprintf('\nCheck the stability of CT systems using the simplified Routh test\n')
%   a=RR_poly([-2.3 -1.7  1  i   -i  ],1), routh_simplified(a) % unstable
%   a=RR_poly([-2.3 -1.7 -1  i   -i  ],1), routh_simplified(a) % marginally stable
%   a=RR_poly([-2.3 -1.7 -1 -1+i -1-i],1), routh_simplified(a) % stable
%   b=RR_poly([1 .3]); a=RR_poly([1 12 20 0 0]); % Example given in Figure 18.4 of NR.
%   den=-0.01*b+a,  routh_simplified(den);
%   den= 0.01*b+a,  routh_simplified(den);
%   den=196.7*b+a,  routh_simplified(den);
%   den=196.9*b+a,  routh_simplified(den);
%   syms K, den=RR_poly(K)*b+a, routh_simplified(den); K_range=eval(solve(K+(18*K)/(5*(K/12-20))==0,K))

%   fprintf('\nCheck the stability of DT systems using the simplified Bistritz test\n')
%   a=RR_poly([-0.99 -.1+i -.1-i 5],1),        abs(roots(a)), bistritz_simplified(a) % unstable
%   a=RR_poly([-0.99   i   -i 1],1),           abs(roots(a)), bistritz_simplified(a) % marginally stable
%   a=RR_poly([-0.99 -.1+.9*i -.1-.9*i .5],1), abs(roots(a)), bistritz_simplified(a) % stable

% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License.

classdef RR_poly < matlab.mixin.CustomDisplay
    properties  % Each RR_poly object consists of the following three fields:
        poly    % The polynomial coefficients themselves, just an ordinary row vector
        n       % The order of this polynomial.  Note that poly has n+1 coefficients
        s       % a T/F flag indicating whether or not poly is symbolic
    end
    methods
        function obj = RR_poly(c,K)          % a=RR_poly creates an RR_poly object obj.
            if nargin==1                     % one argument: create obj for c = vector of coefficients            
                 obj.poly = c;
                 obj.n    = length(c)-1; 
            else                             % two arguments: create obj for c = vector of roots, K = gain
                 obj=RR_poly([1]); index=1;  
                 for k=1:length(c), obj=obj*RR_poly([1 -c(k)]); end; obj=obj*K;
            end
            obj.s=~isnumeric(obj.poly);
        end
        function sum = plus(a,b)          % Defines a+b
            [a,b]=check(a,b); sum=RR_poly([zeros(1,b.n-a.n) a.poly]+[zeros(1,a.n-b.n) b.poly]);
        end
        function diff = minus(a,b)        % Defines a-b
            [a,b]=check(a,b); diff=RR_poly([zeros(1,b.n-a.n) a.poly]-[zeros(1,a.n-b.n) b.poly]);
        end    
        function prod = mtimes(a,b)       % Defines a*b
            [a,b]=check(a,b); p=zeros(1,b.n+a.n+1);
            for k=0:b.n; p=p+[zeros(1,b.n-k) b.poly(b.n+1-k)*a.poly zeros(1,k)]; end
            prod=RR_poly(p);
        end
        function [quo,rem] = rdivide(b,a) % Defines [quo,rem]=b./a
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
        % Define a<b, a>b, a<=b, a>=b, a~=b, a==b based on the orders of a and b.
        function TF=lt(a,b), if a.n< b.n, TF=true; else, TF=false; end, end
        function TF=gt(a,b), if a.n> b.n, TF=true; else, TF=false; end, end
        function TF=le(a,b), if a.n<=b.n, TF=true; else, TF=false; end, end
        function TF=ge(a,b), if a.n>=b.n, TF=true; else, TF=false; end, end
        function TF=ne(a,b), if a.n~=b.n, TF=true; else, TF=false; end, end
        function TF=eq(a,b), if a.n==b.n, TF=true; else, TF=false; end, end
        function [a,b]=check(a,b)
            if ~isa(a,'RR_poly'), a=RR_poly(a); end,  if ~isa(b,'RR_poly'), b=RR_poly(b); end
        end
        function n = norm(a,option)       % Defines n=norm(a,option), where a is an RR_poly object
            if nargin<2, option=2; end    % Second argument is optional [see "help norm"]
            n = norm(a.poly,option);
        end
        function r = roots(p)             % Defines r=roots(p), where p is an RR_poly object
            r=sort(roots(p.poly)).';
        end
        function z = evaluate(a,s)
            z=0; for k=1:a.n+1; z=z+a.poly(k)*s^(a.n+1-k); end
        end
        function p = derivative(p,m)      % Computes the m'th derivative of the polynomial p
            if m==0, return, elseif nargin<2, m=1; end
            p.poly=[p.n:-1:1].*p.poly(1:p.n); p.n=length(p.poly)-1;
            if p.n<0, p=RR_poly(0);  end
            if m>1,   p=derivative(p,m-1); end
        end
        function p = trim(p)
            index=find(abs(p.poly(1:end-1))>1e-10,1);   % Trim off any leading zeros in p
            if isempty(index), index=length(p.poly); end 
            p.poly = c(p.poly:end);
            p.n    = length(p.poly)-1;
        end
        function out = invert(p)
            out = RR_poly(p.poly(end:-1:1));
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function inertia = routh(a)
        % function inertia = routh(a)
        % Find the number of roots of the polynomial a(s) that are in the LHP, on the
        % imaginary axis, and in the RHP, referred to as the inertia of a(s), WITHOUT
        % calculating the roots of the polynomial a(s).  Algorithm due to Routh (1895).
        % INPUT:  a = RR_poly object (the denominator of the CT transfer function of interest)
        % OUTPUT: inertia = vector quantifying number of [LHP imaginary RHP] roots 
            p=a.poly; deg=a.n; inertia=[0 0 0]; flag=0; show_routh('Routh',deg,p(1:2:end))
            for n=deg:-1:1    % Note: implementation follows that in Meinsma (SCL, 1995)
                k=find(abs(p(2:2:n+1))>1e-14,1); show_routh('Routh',n-1,p(2:2:end))  
                if length(k)==0, flag=1;                                 
                    if mod(n,2)==0, t='Even'; else, t='Odd'; end
                    disp(['Case 3: ',t,' polynomial. Add its derivative.'])
                    p(2:2:n+1)=p(1:2:n).*(n:-2:1); show_routh('  NEW',n-1,p(2:2:end))
                elseif k>1
                    if mod(k,2)==0, s=-1; t='Subtract'; else, s=1; t='Add'; end
                    disp(['Case 2: p_{n-1}=0. ',t,' s^',num2str(2*(k-1)),' times row ',num2str(n-1),'.'])
                    i=0:2:(n+1-2*k); p(i+2)=p(i+2)+s*p(i+2*k); show_routh('  NEW',n-1,p(2:2:end))
                end
                eta=p(1)/p(2);  if flag, inertia=inertia+[(eta<0) 0 (eta<0)];
                                else,    inertia=inertia+[(eta>0) 0 (eta<0)]; end
                p(3:2:n)=p(3:2:n)-eta*p(4:2:n+1); p=p(2:n+1);  % Update p, strip off leading element
            end
            inertia=inertia+[0 deg-sum(inertia) 0]; s='stable CT system';
            if inertia(3)>0 s=['un',s]; elseif inertia(2)>0 s=['marginally ',s]; end, disp(s)
            function show_routh(t,num,data)
                disp([t,' row ',num2str(num),':',sprintf(' %7.4g',data)])
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function routh_simplified(a)
        % function routh_simplified(a)
        % Compute the simplified Routh table to determine if a(s) is Hurwitz (all eigenvalues in LHP).
        % Significantly, note that a(s) may be symbolic.
        % INPUT:  a = RR_poly object (the denominator of the CT transfer function of interest)
        % OUTPUT: none (Routh table is just printed to the screen) 
            p=a.poly; n=a.n; s=strcmp(class(p),'sym'); R=0; f=1; disp(p(1:2:end));
            for i=n:-1:1
               disp(p(2:2:end)), if p(2)==0, disp('Not Hurwitz.'), f=0; break, end
               a=p(1)/p(2); p(3:2:i)=p(3:2:i)-a*p(4:2:i+1); p=p(2:i+1); if ~s, if a<0, R=R+1; end, end
            end
            if f
                if s, disp('Hurwitz iff all entries in first column are the same sign.')
                else, if R==0, disp('Hurwitz'), else, disp(['Not Hurwitz: ',num2str(R),' RHP poles']), end
                end
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function stationarity = bistritz(a)
        % function stationarity=bistritz(a)
        % Find the number of roots of the polynomial a(z) that are inside, on, and outside the
        % unit circle, referred to as the stationarity of a(z), WITHOUT calculating the roots
        % of the polynomial a(z).  Algorithm due to Bistritz (2002).
        % Note: The Schur-Cohn and Jury tests (not coded here) are alternatives to the Bistritz test
        % for calculating the stationarity of a(z).
        % INPUT:  a = RR_poly object (the denominator of the DT transfer function of interest)
        % OUTPUT: stationarity = vector quantifying number of roots [inside on outside] the unit circle   
            z1roots=0;
            while abs(evaluate(a,1))<1e-12, a=a./[1 -1]; z1roots=z1roots+1; end  % roots at z=1
            disp(['  Simplified a:',sprintf(' %7.4g',a.poly)])
            deg=a.n; T2=a+invert(a); T1=(a-invert(a))./[1 -1];
            show_bistritz('Bistritz',deg,T2)
            show_bistritz('Bistritz',deg-1,T1), nu_n=0; nu_s=0; s=0;
            for n=deg-1:-1:0
                if norm(T1,1)>1e-12,
                    k=find(abs(T1.poly)>1e-14,1)-1; d=T2.poly(1)/T1.poly(1+k);
                    T1head=RR_poly(T1.poly(1:end-k)); T1tail=RR_poly([T1.poly(1+k:end) zeros(1,k+1)]);
                    a=d*(T1head+T1tail)-T2;
                    T0=RR_poly(a.poly(2:n+1));
                elseif T2.poly(1)==0,
                    T0=RR_poly(-T2.poly(2:n+1));
                else                                                          % Singular case
                    a=RR_poly(T2.poly(1:n+1).*(n+1:-1:1));
                    a.poly=-a.poly(end:-1:1); if (s==0), s=n+1; end
                    T1=a+invert(a); T0=(a-invert(a))./[1 -1];
                    show_bistritz('     NEW',n,T1)
                end
                eta=(evaluate(T2,1)+eps)/(evaluate(T1,1)+eps);  nu_n=nu_n+(eta<0);
                if (s>0), nu_s=nu_s+(eta<0); end
                if n>0, show_bistritz('Bistritz',n-1,T0); T2=T1; T1=T0; end
            end
            disp(['nu_n=',num2str(nu_n),' s=',num2str(s),' nu_s=',num2str(nu_s)])
            a=deg-nu_n; b=2*nu_s-s; c=deg-a-b; stationarity=[a b+z1roots c]; s='stable DT system';
            if stationarity(3)>0, s=['un',s]; elseif stationarity(2)>0, s=['marginally ',s]; end, disp(s)
            function show_bistritz(t,num,data)
                disp([t,' row ',num2str(num),':',sprintf(' %7.4g',data.poly)])
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function bistritz_simplified(a)
        % function bistritz_simplified(a)
        % Compute the simplified Bistritz table to determine if a(z) is Schur (all eigenvalues in unit circle).
        % Significantly, note that a(z) may be symbolic.
        % INPUT:  a = RR_poly object (the denominator of the DT transfer function of interest)
        % OUTPUT: none (Bistritz table is just printed to the screen) 
            s=strcmp(class(a.poly),'sym'); R=0; f=1; disp('Simplified Bistritz table:')
            uip2=a+invert(a);           uip20=uip2.poly(end); disp(uip2.poly)
            uip1=(a-invert(a))./[1 -1]; uip10=uip1.poly(end); disp(uip1.poly)
            for i=a.n-2:-1:0
                c=uip20/uip10;    if c==0, disp('Not Schur.'), f=0; break, end
                ui=RR_poly(c)*(RR_poly([1 1])*uip1-uip2);
                ui.poly=ui.poly(2:end-1); ui.n=ui.n-2; disp(ui.poly)
                uip2=uip1; uip20=uip10; uip1=ui; uip10=ui.poly(end);
                if ~s, if c<=0, R=R+1; end, end
            end
            c=uip20/uip10; if ~s, if c<=0, R=R+1; end, end
            if f
                if s, disp('Schur iff all entries in first column are the same sign.')
                else, if R==0, disp('Schur.'), else, disp(['Not Schur.']), end
                end
            end
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods(Access = protected)
        function displayScalarObject(obj)
            fprintf(getHeader(obj)),
            fprintf('poly: '), disp(obj.poly)
            if ~obj.s, fprintf('roots:'), disp(sort(roots(obj.poly),'ComparisonMethod','real').'), end
            fprintf('   n: %d\n',obj.n)
        end
    end
end
