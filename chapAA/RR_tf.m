% classdef RR_tf
%
% This class defines a set of operations on transfer functions, each given by a pair of 
% numerator and denominator polynomials of the RR_poly class, and the equivalent (z,p,K) representation.
% In contrast to the Matlab 'tf' command, the RR_tf class definition automatically performs pole/zero cancellations,
% and can robustly handle a mixture of numeric and symbolic data.
% Try, for example, syms z1, G=RR_tf([z1 z1 3 4],[4 5 6 z1],1), T=G./(1+G)
% DEFINITION:
%   G=RR_tf(num)      1 argument  defines an RR_tf object G from a numerator polynomial, setting denominator=1
%   G=RR_tf(num,den)  2 arguments defines an RR_tf object from numerator and denominator polynomials
%   G=RR_tf(z,p,K)    3 arguments defines an RR_tf object from vectors of zeros and poles, z and p, and the gain K
%   Note that any RR_tf object G has two RR_poly fields, G.num and G.den
% STANDARD OPERATIONS (overloading the +, -, *, ./ operators):
%   plus:     G1+G2  gives the sum of two transfer functions        (or, a transfer functions and a scalar)
%   minus:    G1-G2  gives the difference of two transfer functions (or, a transfer functions and a scalar)
%   mtimes:   G1*G2  gives the product of two transfer functions    (or, a transfer functions and a scalar)
%   rdivide:  G1./G2 divides two transfer functions
%   mpower:   G1^n  gives the n'th power of a transfer function
% SOME TESTS:  [Try them! Change them!]
%   G=RR_tf([1.1 10 110],[0 1 10 100],1), D=RR_tf([1 2],[4 5])       % Define a couple of test transfer functions
%   T=G*D./(1+G*D)
% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
% Copyright 2022 by Thomas Bewley, distributed under BSD 3-Clause License.

classdef RR_tf < matlab.mixin.CustomDisplay
    properties
    	num  % num and den are of type RR_poly 
    	den
        h    % timestep for discrete-time TF representations (empty for continuous-time TF representations)
        z    % z and k are row vectors, and K is an ordinary scalar
        p
        K    % Note that the (num,den) and (z,p,K) representations of the transfer function are equivalent
    end
    methods
    	function obj = RR_tf(a,b,c)
            % Generate an RR_tf object:
            %   called with 1 argument,  generates from a numerator polynomial a, setting denominator=1
            %   called with 2 arguments, generates from a numerator polynomial a and a denominator polynomial b
            %   called with 3 arguments, generates from vectors of zeros and poles, a and b, and the overall gain c
            % Automatically performs pole/zero cancellations as necessary
    		switch nargin
    			case 1  
    				if ~isa(a,'RR_poly'), a=RR_poly(a); end, obj = RR_tf(a,RR_poly(1));
    			case 2 	
     				if  isa(a,'RR_poly'), obj.num=a; else, obj.num=RR_poly(a); end
   					if  isa(b,'RR_poly'), obj.den=b; else, obj.den=RR_poly(b); end
   					t=1/obj.den.poly(1); obj.den=obj.den*t; obj.num=obj.num*t;  % Make denominator monic
                    obj.z=roots(obj.num); obj.p=roots(obj.den);
                    % if  obj.num.s, obj.z=sym('z',[1 obj.num.n]); else, obj.z=roots(obj.num); end
                    % if  obj.den.s, obj.p=sym('p',[1 obj.den.n]); else, obj.p=roots(obj.den); end
                    obj.K=obj.num.poly(1); 
   				case 3	
                    obj.z=a; obj.p=b; obj.K=c;
    	    		obj.num=RR_poly(a,'roots'); obj.num.poly=c*obj.num.poly;
                    obj.den=RR_poly(b,'roots');
    	    end
            G.h=[];
     	    if obj.num.poly==0, obj.den=RR_poly(1); fprintf('Simplifying the zero transfer function\n'), end 
            if obj.num.n>0 & obj.den.n>0
                for i=1:obj.num.n        % Perform pole/zero cancellations!
                    TF=RR_eq(obj.z(i),obj.p,1e-3); modified=false;
                    for j=1:obj.den.n, if TF(j)
                        fprintf('Performing pole/zero cancellation at s='), disp(obj.z(i))
                        obj.z=obj.z([1:i-1,i+1:obj.num.n]);
                        obj.p=obj.p([1:j-1,j+1:obj.den.n]); modified=true; break
                    end, end
                    if modified, obj=RR_tf(obj.z,obj.p,obj.K); break, end
                end
              %  if ~modified, obj=RR_tf(obj.num,obj.den); end
            if ~isnumeric(obj.z), obj.z=simplify(obj.z); obj.num.poly=simplify(obj.num.poly); end
            if ~isnumeric(obj.p), obj.p=simplify(obj.p); obj.den.poly=simplify(obj.den.poly); end
            end
    	end
    	function sum = plus(G1,G2)          
            % Defines G1+G2, where G1 and/or G2 are of class RR_tf
            % If G1 or G2 is a scalar, vector, or of class RR_poly, it is first converted to class RR_tf   
            [G1,G2]=check(G1,G2);  g=RR_GCF(G1.den,G2.den);  % (Dividing out the GCF improves accuracy)
            sum  = RR_tf(G1.num*(G2.den./g)+G2.num*(G1.den./g),G1.den*(G2.den./g));
            if ~isempty(G1.h); sum.h=G1.h; end
        end
        function diff = minus(G1,G2)       
            % Defines G1-G2, where G1 and/or G2 are of class RR_tf
            % If G1 or G2 is a scalar, vector, or of class RR_poly, it is first converted to class RR_tf   
            [G1,G2]=check(G1,G2);  g=RR_GCF(G1.den,G2.den);  % (Dividing out the GCF improves accuracy)
            diff = RR_tf(G1.num*(G2.den./g)-G2.num*(G1.den./g),G1.den*(G2.den./g));
            if ~isempty(G1.h); diff.h=G1.h; end
        end    
        function prod = mtimes(G1,G2)       
            % Defines G1*G2, where G1 and/or G2 are of class RR_tf
            % If G1 or G2 is a scalar, vector, or of class RR_poly, it is first converted to class RR_tf   
            [G1,G2]=check(G1,G2); prod = RR_tf(G1.num*G2.num,G1.den*G2.den);
            if ~isempty(G1.h); prod.h=G1.h; end
        end
        function quo = rdivide(G1,G2)
            % Defines G1./G2, where G1 and/or G2 are of class RR_tf
            % If G1 or G2 is a scalar, vector, or of class RR_poly, it is first converted to class RR_tf   
            [G1,G2]=check(G1,G2); quo  = RR_tf(G1.num*G2.den,G1.den*G2.num);
            if ~isempty(G1.h); quo.h=G1.h; end
        end
        function pow = mpower(G1,n)        % Defines G1^n
             if n==0, pow=RR_tf([1]); else, pow=G1; for i=2:n, pow=pow*G1; end, end
            if ~isempty(G1.h); pow.h=G1.h; end
        end
        function [G1,G2]=check(G1,G2)
            % Converts G1 or G2, as necessary, to the class RR_tf
            if ~isa(G1,'RR_tf'), G1=RR_tf(G1); end,  if ~isa(G2,'RR_tf'), G2=RR_tf(G2); end
            if     ~isempty(G1.h) & ~isempty(G2.h) & G1.h==G2.h, % disp 'valid DT TF operation'
            elseif  isempty(G1.h) &  isempty(G2.h),              % disp 'valid CT TF operation'
            else    error('Incompatible operation on transfer functions!')
            end
        end
        function z = evaluate(G,s)
            for i=1:length(s)
                n=0; for k=1:G.num.n+1; n=n+G.num.poly(k)*s(i)^(G.num.n+1-k); end
                d=0; for k=1:G.den.n+1; d=d+G.den.poly(k)*s(i)^(G.den.n+1-k); end, z(i)=n/d;
            end
        end

        function [p,d,k,n]=PartialFractionExpansion(F,tol)
            % Compute {p,d,k,n} so that F(s)=num(s)/den(s)=d(1)/(s-p(1))^k(1) +...+ d(n)/(s-p(n))^k(n)
            % INPUTS:  F   a (proper or improper) rational polynomial of class RR_tf
            %          tol tolerance used when calculating repeated roots
            % OUTPUTS: p   poles of F (a row vector of length n)
            %          d   coefficients of the partial fraction expansion (a row vector of length n)
            %          k   powers of the denominator in each term (a row vector of length n)
            %          n   number of terms in the expansion
            % TESTS:   % The first example computes the Partial Fraction Expansion of a second-order strictly proper
            %          % TF that is only defined symbolically. (top that, Mathworks!) It then assigns some values.
            %          clear, syms c1 c0 a1 a0, F=RR_tf([c1 c0],[1 a1 a0])
            %          [p,d,k,n]=PartialFractionExpansion(F)
            %          c0=2; c1=1; a1=4; a0=3; eval(p), eval(d)
            %          % The second example generates an (improper) TF, computes its Partial Fraction Expansion,
            %          % then reconstructs the TF from this Partial Fraction Expansion.  Cool.
            %          F=RR_tf([1 2 2 3 5],[1 7 7],1), [p,d,k,n]=PartialFractionExpansion(F)
            %          F1=RR_tf(0,1); for i=1:n, if k(i)>0, F1=F1+RR_tf( d(i), RR_poly([1 -p(i)])^k(i) ); ...
            %             else, F1=F1+RR_tf([d(i) zeros(1,abs(k(i)))]); end, end  
            % Renaissance Robotics codebase, Appendix B, https://github.com/tbewley/RR

            m=F.num.n; n=F.den.n; flag=0; if m>=n, [div,rem]=F.num./F.den; flag=1; m=rem.n; else, rem=F.num; end
            k=ones(1,n); p=F.p; if nargin<2, tol=1e-3; end
            for i=1:n-1, if RR_eq(p(i+1),p(i),tol), k(i+1)=k(i)+1; end, end, k(n+1)=0;
            for i=n:-1:1
                if k(1,i)>=k(i+1), r=k(i); a=RR_poly(1);
                    for j=1:i-k(i),    a=a*[1 -p(j)]; end
                    for j=i+1:n,       a=a*[1 -p(j)]; end
                    for j=1:k(i)-1,    ad{j}=diff(a,j); end
                end
                q=r-k(i); d(i)=evaluate(diff(rem,q),p(i))/RR_Factorial(q);
                for j=q:-1:1, d(i)=d(i)-d(i+j)*evaluate(ad{j},p(i))/RR_Factorial(j); end
                d(i)=d(i)/evaluate(a,p(i));
            end, if ~flag, k=k(1:n); else
                 p(n+1:n+1+div.n)=0; d(n+1:n+div.n+1)=div.poly(end:-1:1); k(n+1:n+1+div.n)=-[0:div.n]; n=n+div.n+1;
            end
            % Remove all terms in the expansion with zero coefficients
            while 1, mask=RR_eq(d,0); i=find(mask,1); if isempty(i), break, else
                p=p([1:i-1,i+1:end]); d=d([1:i-1,i+1:end]);  k=k([1:i-1,i+1:end]); n=n-1;
            end, end
        end % function PartialFractionExpansion

        function bode(L,g)
            % function bode(L,g)
            % The continuous-time Bode plot of G(s)=num(s)/den(s) if nargin=3, with s=(i omega), or
            % the discrete-time   Bode plot of G(z)=num(z)/den(z) if nargin=4, with z=e^(i omega h).
            % Note: the (optional) derived type g is used to pass in various (optional) plotting parameters:
            %   {g.log_omega_min,g.log_omega_max,G.omega_N} define the set of frequencies used (logarithmically spaced)
            %   g.linestyle is the linestyle used
            %   g.lines is a logical flag turning on/off horizontal_lines at gain=1 and phase=-180 deg
            %   g.phase_shift is the integer multiple of 360 deg added to the phase in the phase plot.
            % Some convenient defaults are defined for each of these fields, but any may be overwritten. You're welcome.
            % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR

            if nargin==1, g=[]; end, p=[abs([L.z L.p])];  % Set up some convenient defaults for the plotting parameters
            if     ~isfield(g,'log_omega_min'), g.log_omega_min=floor(log10(min(p(p>0))/5)); end
            % (In DT, always plot the Bode plot up to the Nyquist frequency, to see what's going on!)
            if     ~isempty(L.h              ), Nyquist=pi/L.h; g.log_omega_max=log10(0.999*Nyquist);
            elseif ~isfield(g,'log_omega_max'), g.log_omega_max= ceil(log10(max(p     )*5)); end
            if     ~isfield(g,'omega_N'      ), g.omega_N      =500;                         end
            if     ~isfield(g,'linestyle'    ), if isempty(L.h), g.linestyle ='b-';
                                                else             g.linestyle ='r-';  end,    end
            if     ~isfield(g,'lines'        ), g.lines        =false;                       end
            if     ~isfield(g,'phase_shift'  ), g.phase_shift  =0;                           end

            omega=logspace(g.log_omega_min,g.log_omega_max,g.omega_N);
            if     ~isempty(L.h), arg=exp(i*omega*L.h); else arg=i*omega; end

            mag=abs(evaluate(L,arg)); phase=RR_Phase(evaluate(L,arg))*180/pi+g.phase_shift*360;

            for k=1:g.omega_N-1; if (mag(k)  -1  )*(mag(k+1)  -1  )<=0;
                omega_c=(omega(k)+omega(k+1))/2, phase_margin=180+(phase(k)+phase(k+1))/2
            break, end, end
            for k=1:g.omega_N-1; if (phase(k)+180)*(phase(k+1)+180)<=0;
                omega_g=(omega(k)+omega(k+1))/2, gain_margin=1/(mag(k)+mag(k+1))/2
            break, end, end

            subplot(2,1,1),        loglog(omega,mag,g.linestyle), hold on, a=axis;
            if g.lines,              plot([a(1) a(2)],[1 1],'k:')
                if exist('omega_c'), plot([omega_c omega_c],[a(3) a(4)],'k:'), end
                if exist('omega_g'), plot([omega_g omega_g],[a(3) a(4)],'k:'), end, end
            if ~isempty(L.h),        plot([Nyquist Nyquist],[a(3) a(4)],'k-'), end, axis(a)

            subplot(2,1,2),      semilogx(omega,phase,g.linestyle), hold on, a=axis;
            if g.lines,              plot([a(1) a(2)],[-180 -180],'k:')
                if exist('omega_c'), plot([omega_c omega_c],[a(3) a(4)],'k:'), end
                if exist('omega_g'), plot([omega_g omega_g],[a(3) a(4)],'k:'), end, end
            if ~isempty(L.h),        plot([Nyquist Nyquist],[a(3) a(4)],'k:'), end, axis(a)
        end % function bode

        function rlocus(G,D)
        end % function rlocus

        function [Yz]=Z(Ys,h)
        % function [Yz]=Z(Ys,h)
        % Compute the Z transform Yz(z) of the DT signal y_k given by sampling (at regular intervals t_k = h k)
        % of the CT signal y(t) with a strictly proper Laplace transform Ys(s).
        % Renaissance Robotics Chapter 9
        % Verify with <a href="matlab:help NRC">C2DzohTest</a>.

            [a,d,k,n]=PartialFractionExpansion(Ys), r=exp(a*h); Yz=RR_tf(0,1);
            for i=1:n, i, if     k(i)<1,   error('CT TF considered must be strictly proper!')
                          elseif k(i)==1,  Yz=Yz+d(i)*RR_tf([1 0],[1 -r(i)]);
                          else,  p=k(i)-1, Yz=Yz+(d(i)/factorial(p))*h^p*RR_Polylogarithm(p,r(i)); end
            end,  Yz.h=h;
        end % function Z

        function [Gz]=C2Dzoh(Gs,h)
        % function [Gz]=C2Dzoh(Gs,h)
        % Compute (exactly) the Gz(z) corresponding to a D/A-Gs(s)-A/D cascade with timestep h.
        % Renaissance Robotics Chapter 9

            HATz=RR_tf([1 -1],[1 0]); HATz.h=h;
            STEPs=RR_tf(1,[1 0]);
            Gz=HATz * Z(Gs*STEPs,h);
        end % function C2Dzoh

        function [Dz]=C2Dtustin(Ds,h,omegac)
        % function [Dz]=RR_C2D_Tustin(Ds,h,omegac)
        % Convert Ds(s) to Dz(z) using Tustin's method.  If omegac is specified, prewarping is applied
        % such that the dynamics of Ds(s) in the vicinity of this critical frequency are mapped correctly.
        % Renaissance Robotics Chapter 9.
 
            if nargin==2, f=1; else, f=2*(1-cos(omegac*h))/(omegac*h*sin(omegac*h)); end
            c=2/(f*h); m=Ds.num.n; n=Ds.den.n; b=RR_poly(0); a=b;
            fac1=RR_poly([1 1]); fac2=RR_poly([1 -1]);
            for j=0:m; b=b+Ds.num.poly(m+1-j)*c^j*fac1^(n-j)*fac2^j; end
            for j=0:n; a=a+Ds.den.poly(n+1-j)*c^j*fac1^(n-j)*fac2^j; end, Dz=RR_tf(b,a); Dz.h=h;
        end % function RR_C2D_Tustin

        function [t,u,y]=plot_response(G,m,g)
        % function [t,u,y]=plot_response(G,m,g)
        % Using partial fraction expansions, compute and plot either:
        %   the response y(t) corresponding to Y(s)=G(s)*U(s) of a CT TF G(s) due to an input u(t), or
        %   the response y_k  corresponding to Y(z)=G(z)*U(z) of a CT TF G(z) due to an input u_k.
        % The CT input u(t), for t>=0, is a unit impulse for m=-1, a unit step for m=0, and u(t)=t^p for m>0, or
        % the DT input u_k,  for k>=0, is a unit impulse for m=-1, a unit step for m=0, and u_k =k^p for m>0.
        % The derived type g groups together convenient plotting parameters:
        %   {g.T,g.N} define the interval and number of timesteps plotted in the CT case, and
        %   g.N       defines the number of timesteps plotted in the DT case,
        %   {g.linestyle_u,g.linestyle_y} are the linestyles used for the input u and the output y
        %   g.tol     defines the tolerance used when checking for repeated roots in the partial fraction expansion. 
        % Some "convenient" defaults are defined for each of these fields, but any may be overwritten. You're welcome.
        % Renaissance Robotics Chapter 9.

            if nargin<2, p=0; end, if nargin<3, g=[]; end      % Set up "convenient" defaults
            if isempty(G.h),   % some defaults for the CT case
                if ~isfield(g,'T'),             g.T=10;              end
                if ~isfield(g,'N'),             g.N=1000;            end
                if ~isfield(g,'linestyle_u'  ), g.linestyle_u='b-.'; end
                if ~isfield(g,'linestyle_y'  ), g.linestyle_y='r-';  end
            else               % some defaults for the DT case
                h=G.h;
                if ~isfield(g,'N'),             g.N=50;              end
                if ~isfield(g,'linestyle_u'  ), g.linestyle_u='bo';  end
                if ~isfield(g,'linestyle_y'  ), g.linestyle_y='rx';  end
            end
            if     ~isfield(g,'tol'  ),         g.tol=1e-4;          end

            if isempty(G.h)  %%%%%%%%%%%%%  CT case  %%%%%%%%%%%%%
                U=RR_tf(RR_Factorial(m),[1 zeros(1,m+1)])             % First, set up U(s)  
                [Up,Ud,Uk,Un]=PartialFractionExpansion(U,g.tol);      % Then take the necessary
                [Yp,Yd,Yk,Yn]=PartialFractionExpansion(G*U,g.tol);    % partial fraction expansions
                h=g.T/g.N; t=[0:g.N]*h;
                for k=1:g.N+1
                    if m>=0, u(k)=real(sum(Ud.*t(k).^(Uk-1).*exp(Up*t(k)))); else, u(k)=0; end
                             y(k)=real(sum(Yd.*t(k).^(Yk-1).*exp(Yp*t(k))));
                end
            else             %%%%%%%%%%%%%  DT case  %%%%%%%%%%%%%    % First, set up R(z)
                if     m==-1, U=h^(-1)*RR_tf(1);                             % unit impulse
                elseif m==0 , U=RR_tf([1 0],[1 -1]);
                else,         U=h^m*RR_Polylogarithm(m,1); end, U.h=h % (h*k)^m for m>=0
                N=g.N; k=[0:N]; t=k*h;
                [Ur,Ud,Up,Un]=PartialFractionExpansion(U,g.tol),   u=zeros(1,N+1);
                [Yr,Yd,Yp,Yn]=PartialFractionExpansion(G*U,g.tol), y=zeros(1,N+1);
                for i=1:Un
                    if Up(i)>0, c=ones(1,N+1)*Ud(i)/(factorial(Up(i)-1)*Ur(i)^(Up(i)));
                            for j=1:Up(i)-1, c=c.*(k-j); end
                               u(Up(i)+1:end)=u(Up(i)+1:end)+c(Up(i)+1:end).*Ur(i).^k(Up(i)+1:end);
                    else, u(1)=u(1)+Ud(i); end
                end
                if m==-1, u=[1, zeros(1,N)]; else, u=(h*k).^m; end
                for i=1:Yn
                    if Yp(i)>0, c=ones(1,N+1)*Yd(i)/(factorial(Yp(i)-1)*Yr(i)^(Yp(i)));
                            for j=1:Yp(i)-1, c=c.*(k-j); end
                               y(Yp(i)+1:end)=y(Yp(i)+1:end)+c(Yp(i)+1:end).*Yr(i).^k(Yp(i)+1:end);
                    else, y(1)=y(1)+Yd(i); end
                end
            end, u=real(u); y=real(y);
            if ~(isempty(G.h) & m==-1), plot(t,u,g.linestyle_u), hold on, end
                                        plot(t,y,g.linestyle_y), hold off
        end % function RR_Response_TF
    end
    methods(Access = protected)
        function displayScalarObject(obj)
            fprintf(getHeader(obj))
            fprintf('num:'), disp(obj.num.poly)
            fprintf('den:'), disp(obj.den.poly)
            if isempty(obj.h), fprintf('Continuous-time transfer function\n'), else
                fprintf('Discrete-time transfer function with h='), disp(obj.h), end
            nr=obj.den.n-obj.num.n;
            if nr>0, s='strictly proper'; elseif nr==0, s='semiproper'; else, s='improper'; end
            fprintf('  m=%d, n=%d, n_r=n-m=%d, %s, K=', obj.num.n, obj.den.n, nr, s), disp(obj.K)
            fprintf('  z:'), disp(obj.z)
            fprintf('  p:'), disp(obj.p)
            if obj.den.n==0, fprintf('\n'), end
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





