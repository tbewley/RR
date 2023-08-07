% classdef RR_tf
% This class defines a set of operations on transfer functions, each given by a pair of 
% numerator and denominator polynomials of the RR_poly class, and the equivalent (z,p,K) representation.
% In contrast to the Matlab 'tf' command, the RR_tf class definition automatically performs pole/zero cancellations,
% and can robustly handle a mixture of numeric and symbolic data.
% Try, for example, syms z1, L=RR_tf([z1 z1 3 4],[4 5 6 z1],1), T=L/(1+L)
%
% DEFINITION:
%   G=RR_tf(num)      1 argument  defines an RR_tf object G from a numerator polynomial, setting denominator=1
%   G=RR_tf(num,den)  2 arguments defines an RR_tf object from numerator and denominator polynomials
%   G=RR_tf(z,p,K)    3 arguments defines an RR_tf object from vectors of zeros and poles, z and p, and the gain K
%   Note that, to generate a DT rational transfer function, use 1 of the above 3 commands, then set G.h.
%   Any RR_tf object G has two RR_poly fields, G.num and G.den
%
% STANDARD OPERATIONS defined on RR_tf objects (overloading the +, -, *, /, ^ operators):
%   plus:     G1+G2  gives the sum of two transfer functions        (or, a transfer functions and a scalar)
%   minus:    G1-G2  gives the difference of two transfer functions (or, a transfer functions and a scalar)
%   mtimes:   G1*G2  gives the product of two transfer functions    (or, a transfer functions and a scalar)
%   rdivide:  G1/G2 divides two transfer functions
%   mpower:   G1^n  gives the n'th power of a transfer function
%
% ADDITIONAL OPERATIONS defined on RR_tf objects (try "help RR_tf/RR_*" for more info on any of them)
%   RR_evaluate: Evaluates a transfer function G(s) at a given value of s.
%   RR_partial_fraction_expansion: Compute {p,d,k,n} such that G(s)=d(1)/(s-p(1))^k(1) +...+ d(n)/(s-p(n))^k(n)
%   RR_bode: Plots the CT Bode plot of G(s) if G.h is not defined, with s=(i omega),
%            or    the DT Bode plot of G(z) if G.h is defined, with z=e^(i omega h).
%   RR_bode_linear: Plots a modified Bode plot with linear axes (frequency and amplitude)
%   RR_rlocus: Plot the root locus of K*G(s)*D(s) w.r.t. a range of K
%   Yz=RR_Z(Ys,h): Compute the Z transform Yz(z) of the DT signal y_k given by sampling (at t_k = h k)
%                  the CT signal y(t) with a strictly proper Laplace transform Ys(s).
%   Gz=RR_C2D_zoh(Gs,h): Compute (exactly) the Gz(z) corresponding to a D/A-Gs(s)-A/D cascade with timestep h.
%   Dz=RR_C2D_tustin(Ds,h,omegac): Convert Ds(s) to Dz(z) using Tustin's method (optionally, with prewarping).
%   RR_impulse: Plots the impulse response of a CT plant G(s) or a DT plant G(z).
%   RR_step:    Plots the step    response of a CT plant G(s) or a DT plant G(z).
%   RR_plot_response: General algorithm for plotting system responce (using partial fraction expansions)
%
% SOME TESTS:  [Try them! Change them!]
%   G=RR_tf([1],[1 0 0],1), D=RR_tf(3.3*[1 .33],[1 3.3]), T=G*D/(1+G*D)
%   close all, figure(1), RR_bode(G), figure(2), RR_bode(D), figure(3), RR_bode(G*D)
%   figure(4), RR_impulse(T), figure(5), RR_step(T)
%   NOTE: type "help RR_*", for any of the above-listed ADDITIONAL OPERATIONS, for further info.
%
% Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
% See also RR_int, RR_poly.

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
    	function G = RR_tf(num,den,K)
        % function G = RR_tf(num,den,K)
        % Generate a CT RR_tf object G(s):
        %   called with 1 argument,  generates from polynomial num, with den=1
        %   called with 2 arguments, generates from polynomials num and den
        %   called with 3 arguments, generates from vectors of zeros (num) and poles (den), and the overall gain K
        % Automatically performs pole/zero cancellations as necessary.
        % To define a DT RR_tf object G(z), define G as above, then set, e.g., G.h=0.01.
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License.
    		switch nargin
    			case 1  
    				if ~isa(num,'RR_poly'), num=RR_poly(num); end, G = RR_tf(num,RR_poly(1));
    			case 2 	
     				if  isa(num,'RR_poly'), G.num=num; else, G.num=RR_poly(num); end
   					if  isa(den,'RR_poly'), G.den=den; else, G.den=RR_poly(den); end
   					t=1/G.den.poly(1); G.den=G.den*t; G.num=G.num*t;  % Make denominator monic
                    G.z=RR_roots(G.num); G.p=RR_roots(G.den);
                    % if  G.num.s, G.z=sym('z',[1 G.num.n]); else, G.z=RR_roots(G.num); end
                    % if  G.den.s, G.p=sym('p',[1 G.den.n]); else, G.p=RR_roots(G.den); end
                    G.K=G.num.poly(1); 
   				case 3	
                    G.z=num; G.p=den; G.K=K; G.num=RR_poly(num,K); G.den=RR_poly(den,1);
    	    end
            G.h=[];
     	    if G.num.poly==0, G.den=RR_poly(1); end  % Simplify the zero transfer function 
            if G.num.n>0 & G.den.n>0
                for i=1:G.num.n        % Perform pole/zero cancellations!
                    TF=RR_eq(G.z(i),G.p,1e-3); modified=false;
                    for j=1:G.den.n, if TF(j)              % perform pole/zero cancellation.
                        G.z=G.z([1:i-1,i+1:G.num.n]);
                        G.p=G.p([1:j-1,j+1:G.den.n]); modified=true; break
                    end, end
                    if modified, G=RR_tf(G.z,G.p,G.K); break, end
                end

                %  if ~modified, G=RR_tf(G.num,G.den); end
                if ~isnumeric(G.z), G.z=simplify(G.z); G.num.poly=simplify(G.num.poly);
                else, G.num=RR_trim(G.num); end
                if ~isnumeric(G.p), G.p=simplify(G.p); G.den.poly=simplify(G.den.poly);
                else, G.den=RR_trim(G.den); end
            end
    	end
    	function sum = plus(G1,G2)          
        % function sum = plus(G1,G2)          
        % Defines G1+G2, where G1 and/or G2 are of class RR_tf
        % If G1 or G2 is a scalar, vector, or of class RR_poly, it is first converted to class RR_tf   
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License.
            [G1,G2]=check(G1,G2);  g=RR_gcd(G1.den,G2.den);  % (Dividing out the gcd improves accuracy)
            sum  = RR_tf(RR_trim(G1.num*(G2.den/g)+G2.num*(G1.den/g)),RR_trim(G1.den*(G2.den/g)));
            if ~isempty(G1.h); sum.h=G1.h; end
        end
        function diff = minus(G1,G2)       
        % function diff = minus(G1,G2)       
        % Defines G1-G2, where G1 and/or G2 are of class RR_tf
        % If G1 or G2 is a scalar, vector, or of class RR_poly, it is first converted to class RR_tf   
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
            [G1,G2]=check(G1,G2);  g=RR_gcd(G1.den,G2.den);  % (Dividing out the gcd improves accuracy)
            diff = RR_tf(G1.num*(G2.den/g)-G2.num*(G1.den/g),G1.den*(G2.den/g));
            if ~isempty(G1.h); diff.h=G1.h; end
        end    
        function prod = mtimes(G1,G2)       
        % function prod = mtimes(G1,G2)       
        % Defines G1*G2, where G1 and/or G2 are of class RR_tf
        % If G1 or G2 is a scalar, vector, or of class RR_poly, it is first converted to class RR_tf   
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
            [G1,G2]=check(G1,G2);
            prod = RR_tf(G1.num*G2.num,G1.den*G2.den);
            if ~isempty(G1.h); prod.h=G1.h; end
        end
        function quo = mrdivide(G1,G2)
        % function quo = mrdivide(G1,G2)
        % Defines G1/G2, where G1 and/or G2 are of class RR_tf
        % If G1 or G2 is a scalar, vector, or of class RR_poly, it is first converted to class RR_tf   
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
            [G1,G2]=check(G1,G2); quo  = RR_tf(G1.num*G2.den,G1.den*G2.num);
            if ~isempty(G1.h); quo.h=G1.h; end
        end
        function pow = mpower(G,n)
        % function pow = mpower(G,n)
        % Defines G^n, where G is of class RR_tf
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License.
             if n==0, pow=RR_tf([1]); else, pow=G; for i=2:n, pow=pow*G; end, end
            if ~isempty(G.h); pow.h=G.h; end
        end
        function [G1,G2]=check(G1,G2)
        % function [G1,G2]=check(G1,G2)
        % Converts G1 or G2, as necessary, to the class RR_tf
        % NOTE: this routine is just used internally in this class definition.
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
            if ~isa(G1,'RR_tf'), G1=RR_tf(G1); if ~isempty(G2.h), G1.h=G2.h; end, end
            if ~isa(G2,'RR_tf'), G2=RR_tf(G2); if ~isempty(G1.h), G2.h=G1.h; end, end
            if     ~isempty(G1.h) & ~isempty(G2.h) & G1.h==G2.h, % disp 'valid DT TF operation'
            elseif  isempty(G1.h) &  isempty(G2.h),              % disp 'valid CT TF operation'
            else    error('Incompatible operation on transfer functions!')
            end
        end

        function z = RR_evaluate(G,s)
        % function z = RR_evaluate(G,s)
        % Evaluates a transfer function G(s), of class RR_tf, at a given value of s.
        % TEST: close all, F=RR_tf([1 1],[1 10]); oc=sqrt(10); RR_bode(F); 
        %       F_at_oc=RR_evaluate(F,oc*i), mag_at_peak=abs(F_at_oc), phase_at_peak=phase(F_at_oc)*180/pi
        %       % The following test code quantifies the phase lead or lag of of a lead compensator (for beta>1)
        %       % or the phase lag of a lag compensator (if beta<1), for a range of beta, where
        %       % F(s)=(s+z)/(s+p) and z=omegac/sqrt(beta), p=omegac*sqrt(beta).
        %       close all, omegac=1; beta=logspace(-3,3,200); n=length(beta)
        %       for k=1:n, z=omegac/sqrt(beta(k)); p=omegac*sqrt(beta(k));
        %          F=RR_tf([1 z],[1 p]); phi(k)=phase(RR_evaluate(F,omegac*i))*180/pi; 
        %       end, semilogx(beta,phi), grid, axis([beta(1) beta(end) -90 90])
        %       title('Phase lead (if beta>1) or lag (if beta<1) of F(s)=(s+z)/(s+p) for beta=p/z')     
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
            for i=1:length(s)
                n=0; for k=1:G.num.n+1; n=n+G.num.poly(k)*s(i)^(G.num.n+1-k); end
                d=0; for k=1:G.den.n+1; d=d+G.den.poly(k)*s(i)^(G.den.n+1-k); end, z(i)=n/d;
            end
        end

        function [p,d,k,n]=RR_partial_fraction_expansion(G,tol)
        % function [p,d,k,n]=RR_partial_fraction_expansion(G,tol)
        % Compute {p,d,k,n} such that G(s)=d(1)/(s-p(1))^k(1) +...+ d(n)/(s-p(n))^k(n)
        % INPUTS:  G   a (proper or improper) rational polynomial of class RR_tf
        %          tol (optional) tolerance used when calculating repeated roots
        % OUTPUTS: p   poles of G (a row vector of length n)
        %          d   coefficients of the partial fraction expansion (a row vector of length n)
        %          k   powers of the denominator in each term (a row vector of length n)
        %          n   number of terms in the expansion
        % TESTS:   % The first example computes the partial fraction expansion of a second-order strictly proper
        %          % TF that is only defined symbolically. (top that, Mathworks!) It then assigns some values.
        %          clear, syms c1 c0 a1 a0, G=RR_tf([c1 c0],[1 a1 a0])
        %          [p,d,k,n]=RR_partial_fraction_expansion(G)
        %          c0=2; c1=1; a1=4; a0=3; p_evaluated=eval(p), d_evaluated=eval(d)
        %          % The second example generates an (improper) G(s), computes its partial fraction expansion,
        %          % then reconstructs G(s) from this partial fraction expansion.  Cool.
        %          G=RR_tf([1 2 2 3 5],[1 7 7],1), [p,d,k,n]=RR_partial_fraction_expansion(G)
        %          G1=RR_tf(0); for i=1:n, if k(i)>0, G1=G1+RR_tf( d(i), RR_poly([1 -p(i)])^k(i) ); ...
        %             else, G1=G1+RR_tf([d(i) zeros(1,abs(k(i)))]); end, end, G1
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
            m=G.num.n; n=G.den.n; flag=0; if m>=n, [div,rem]=G.num/G.den; flag=1; m=rem.n; else, rem=G.num; end
            k=ones(1,n); p=G.p; if nargin<2, tol=1e-3; end
            for i=1:n-1, if RR_eq(p(i+1),p(i),tol), k(i+1)=k(i)+1; end, end, k(n+1)=0;
            for i=n:-1:1
                if k(1,i)>=k(i+1), r=k(i); a=RR_poly(1);
                    for j=1:i-k(i),    a=a*[1 -p(j)]; end
                    for j=i+1:n,       a=a*[1 -p(j)]; end
                    for j=1:k(i)-1,    ad{j}=RR_derivative(a,j); end
                end
                q=r-k(i); d(i)=RR_evaluate(RR_derivative(rem,q),p(i))/factorial(q);
                for j=q:-1:1, d(i)=d(i)-d(i+j)*RR_evaluate(ad{j},p(i))/factorial(j); end
                d(i)=d(i)/RR_evaluate(a,p(i));
            end, if ~flag, k=k(1:n); else
                 p(n+1:n+1+div.n)=0; d(n+1:n+div.n+1)=div.poly(end:-1:1); k(n+1:n+1+div.n)=-[0:div.n]; n=n+div.n+1;
            end
            % Remove all terms in the expansion with zero coefficients
            while 1, mask=RR_eq(d,0); i=find(mask,1); if isempty(i), break, else
                p=p([1:i-1,i+1:end]); d=d([1:i-1,i+1:end]);  k=k([1:i-1,i+1:end]); n=n-1;
            end, end
        end % function RR_partial_fraction_expansion

        function RR_bode(L,g)
        % function RR_bode(L,g)
        % Plots the continuous-time Bode plot of L(s) if L.h is not defined, with s=(i omega),
        % or    the discrete-time   Bode plot of L(z) if L.h is defined,     with z=e^(i omega h).
        % The (optional) derived type g is used to pass in various (optional) plotting parameters:
        %   {g.log_omega_min,g.log_omega_max,G.omega_N} define the set of frequencies used (logarithmically spaced)
        %   g.linestyle is the linestyle used
        %   g.lines is a logical flag turning on/off horizontal_lines at gain=1 and phase=-180 deg
        %   g.phase_shift is the integer multiple of 360 deg added to the phase in the phase plot.
        %   g.Hz is a logical that, if true, handles all frequencies (inputs and plotted) in Hz
        % Convenient defaults are defined for each of these fields of g if not provided.
        % TEST: omegac=1; F=RR_tf([omegac^2],[1 2*0.707*omegac omegac^2]); close all, RR_bode(F)
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
            if nargin==1, g=[]; end,     % Convenient defaults for the plotting parameters
            c=1; if ~isfield(g,'Hz'  ),  g.Hz=false;                       
                 elseif g.Hz==true,      c=2*pi;      end
            p=[abs([L.z L.p])]/c;  if sum(p)==0, p=1; end
            if     ~isfield(g,'log_omega_min'), g.log_omega_min=floor(log10(min(p(p>0))/5)); end
            % (In DT, always plot the Bode plot up to the Nyquist frequency, to see what's going on!)
            if     ~isempty(L.h              ), Nyquist=pi/L.h/c; g.log_omega_max=log10(0.999*Nyquist);
            elseif ~isfield(g,'log_omega_max'), g.log_omega_max= ceil(log10(max(p(p>0))*5)); end
            if     ~isfield(g,'omega_N'      ), g.omega_N      =500;                         end
            if     ~isfield(g,'linestyle'    ), if isempty(L.h), g.linestyle ='b-';
                                                else             g.linestyle ='r-';  end,    end
            if     ~isfield(g,'lines'        ), g.lines        =false;                       end
            if     ~isfield(g,'phase_shift'  ), g.phase_shift  =0;                           end
            omega=logspace(g.log_omega_min,g.log_omega_max,g.omega_N);
            if     ~isempty(L.h), arg=exp(i*omega*c*L.h); else, arg=i*omega*c; end

            mag=abs(RR_evaluate(L,arg)); phase=RR_phase(RR_evaluate(L,arg))*180/pi+g.phase_shift*360;

            if g.lines
            for k=1:g.omega_N-1; if (mag(k)  -1  )*(mag(k+1)  -1  )<=0;
                omega_c=(omega(k)+omega(k+1))/2, phase_margin=180+(phase(k)+phase(k+1))/2
            break, end, end
            for k=1:g.omega_N-1; if (phase(k)+180)*(phase(k+1)+180)<=0;
                omega_g=(omega(k)+omega(k+1))/2, gain_margin=1/(mag(k)+mag(k+1))/2
            break, end, end
            end

            subplot(2,1,1),        loglog(omega,mag,g.linestyle), hold on, a=axis;
            if g.lines,              plot([a(1) a(2)],[1 1],'k:')
                if exist('omega_c'), plot([omega_c omega_c],[a(3) a(4)],'k:'), end
                if exist('omega_g'), plot([omega_g omega_g],[a(3) a(4)],'k:'), end, end
            if ~isempty(L.h),        plot([Nyquist Nyquist],[a(3) a(4)],'k-'), end, axis(a), grid

            subplot(2,1,2),      semilogx(omega,phase,g.linestyle), hold on, a=axis;
            if g.lines,              plot([a(1) a(2)],[-180 -180],'k:')
                if exist('omega_c'), plot([omega_c omega_c],[a(3) a(4)],'k:'), end
                if exist('omega_g'), plot([omega_g omega_g],[a(3) a(4)],'k:'), end, end
            if ~isempty(L.h),        plot([Nyquist Nyquist],[a(3) a(4)],'k:'), end, axis(a), grid
        end % function RR_bode

        function RR_bode_linear(L,g)
        % function RR_bode_linear(L,g)
        % Plots the continuous-time Bode plot of L(s) if L.h is not defined, with s=(i omega),
        % or    the discrete-time   Bode plot of L(z) if L.h is defined,     with z=e^(i omega h).
        % The (optional) derived type g is used to pass in various (optional) plotting parameters:
        %   {g.omega_max,G.omega_N} define the set of frequencies used (linearly spaced)
        %   g.linestyle is the linestyle used
        %   g.Hz is a logical that, if true, handles all frequencies (inputs and plotted) in Hz
        % Convenient defaults are defined for each of these fields of g if not provided.
        % TEST: F=RR_LPF_elliptic(4,0.3,0.04,10), close all, RR_bode_linear(F)
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
            if nargin==1, g=[]; end,   % Set up some convenient defaults for the plotting parameters
            c=1; if ~isfield(g,'Hz'  ),  g.Hz=false;                       
                 elseif g.Hz==true,      c=2*pi;      end
            p=[abs([L.z L.p])]/c;  if sum(p)==0, p=1; end
            % (In DT, always plot the Bode plot up to the Nyquist frequency, to see what's going on!)
            if     ~isempty(L.h          ), Nyquist=pi/L.h/c; g.omega_max=(0.999*Nyquist);
            elseif ~isfield(g,'omega_max'), g.omega_max=((max(p(p>0))*1.5)); end
            if     ~isfield(g,'omega_N'  ), g.omega_N      =500;                end
            if     ~isfield(g,'linestyle'), if isempty(L.h), g.linestyle ='b-';
                                            else             g.linestyle ='r-'; end, end
            omega=linspace(0,g.omega_max,g.omega_N);
            if     ~isempty(L.h), arg=exp(i*omega*c*L.h); else, arg=i*omega*c;  end

            mag=abs(RR_evaluate(L,arg)); phase=RR_phase(RR_evaluate(L,arg))*180/pi;
            subplot(2,1,1),        plot(omega,mag,g.linestyle), hold on, axis tight; a=axis;
            if ~isempty(L.h),      plot([Nyquist Nyquist],[a(3) a(4)],'k-'), end, axis(a), grid
            subplot(2,1,2),        plot(omega,phase,g.linestyle), hold on, axis tight; a=axis;
            if ~isempty(L.h),      plot([Nyquist Nyquist],[a(3) a(4)],'k:'), end, axis(a), grid
        end % function RR_bode_linear

        function RR_rlocus(G,D,g)
        % function RR_rlocus(G,D,g)
        % Plot the root locus of K*G(s)*D(s) w.r.t. a range of K
        % INPUTS: G = plant, of type RR_tf
        %         D = controller, of type RR_tf [OPTIONAL; default is D=1]
        %         g = OPTIONAL derived type with convenient plotting parameters:
        %             g.K is the additional gains used [default: g.K=logspace(-2,2,500)]
        %             g.axes is the axis limits        [default contains all breakpoints]
        % NOTE:   The roots for K=1 are marked (*).
        % TEST:   clear; close all, G1=RR_tf([],[-3 1],2), Ds=RR_tf(2.5); h=0.2, d=h/2
        %         figure(1), RR_rlocus(G1,Ds)
        %         Gd=RR_tf([1 -6/d 12/d^2],[1 6/d 12/d^2]), G2=G1*Gd;
        %         figure(2), g.K=logspace(-2,4,1500);  RR_rlocus(G2,Ds,g)
        %         G3z=RR_C2D_zoh(G1,h), Dz=Ds; Dz.h=h;
        %         figure(3), RR_rlocus(G3z,Dz,g)
        % Renaissance Robotics codebase, Chapter 11, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
            if nargin<3, g={}; end   % Set up convenient defaults for plotting
            if nargin<2; D=RR_tf(1); if ~isempty(G.h), D.h=G.h; end, end        
            L=G*D; T=L/(1+L);
            t=[G.p G.z D.p D.z T.p T.z]*1.6;
            c=1; if ~isfield(g,'Hz'  ),  g.Hz=false;                       
                 elseif g.Hz==true,      c=2*pi;      end
            if ~isfield(g,'K'   ), g.K=logspace(-2,2,500); end
            if ~isfield(g,'axes'), a(1)=min([real(t) -2]); a(2)=max([real(t) 1]);
                                   a(3)=min([imag(t) -1]); a(4)=max([imag(t) 1]); g.axes=a; end
            MS='MarkerSize';
            plot(real(G.p),imag(G.p),'kx',MS,17), axis equal, axis(g.axes), hold on
            plot(real(G.z),imag(G.z),'ko',MS,12)
            plot(real(D.p),imag(D.p),'bx',MS,17)
            plot(real(D.z),imag(D.z),'bo',MS,12)
            plot(real(T.p),imag(T.p),'r*',MS,17)
            for j=1:length(g.K); Ls=L*g.K(j); Tj=Ls/(1+Ls); plot(real(Tj.p),imag(Tj.p),'k.',MS,10); end
            if isempty(G.h)
                grid, plot(5*[a(1) a(2)],[0 0],'k-'), plot([0 0],5*[a(3) a(4)],'k-')
            else
                axis([-1.3 1.3 -1.3 1.3]), zgrid, 
            end
        end % function RR_rlocus

        function [Yz]=RR_Z(Ys,h)
        % function [Yz]=RR_Z(Ys,h)
        % Compute the Z transform Yz(z) of the DT signal y_k given by sampling (at regular intervals t_k = h k)
        % the CT signal y(t) with a strictly proper Laplace transform Ys(s).
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
            [a,d,k,n]=RR_partial_fraction_expansion(Ys); r=exp(a*h); Yz=RR_tf(0,1);
            for i=1:n,  if     k(i)<1,   error('CT TF considered must be strictly proper!')
                        elseif k(i)==1,  Yz=Yz+d(i)*RR_tf([1 0],[1 -r(i)]);
                        else,  p=k(i)-1, Yz=Yz+(d(i)/factorial(p))*h^p*RR_polylogarithm(p,r(i)); end
            end,  Yz.h=h;
        end % function RR_Z

        function [Gz]=RR_C2D_zoh(Gs,h)
        % function [Gz]=RR_C2D_zoh(Gs,h)
        % Compute (exactly) the Gz(z) corresponding to a D/A-Gs(s)-A/D cascade with timestep h.
        % TEST: bs=[1]; as=[1 2 1]; h=0.01; Gs=RR_tf(bs,as), [Gz]=RR_C2D_zoh(Gs,h)
        %       disp('Corresponding Matlab solution:'), c2d(tf(bs,as),h,'zoh')
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License.
            HATz=RR_tf([1 -1],[1 0]); HATz.h=h;
            STEPs=RR_tf(1,[1 0]);
            Gz=HATz * RR_Z(Gs*STEPs,h);
        end % function RR_C2D_zoh

        function [Dz]=RR_C2D_tustin(Ds,h,omegac)
        % function [Dz]=RR_C2D_tustin(Ds,h,omegac)
        % Convert Ds(s) to Dz(z) using Tustin's method.  If omegac is specified, prewarping is applied
        % such that the dynamics of Ds(s) in the vicinity of this critical frequency are mapped correctly.
        % TEST: ys=20*[1 1]; xs=[1 10]; h=0.01; Ds=RR_tf(ys,xs); omegac=sqrt(10); [Dz]=RR_C2D_tustin(Ds,h,omegac)
        %       disp('Corresponding Matlab solution:')
        %       opt = c2dOptions('Method','tustin','PrewarpFrequency',omegac); c2d(tf(ys,xs),h,opt)
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
            if nargin==2, f=1; else, f=2*(1-cos(omegac*h))/(omegac*h*sin(omegac*h)); end
            c=2/(f*h); m=Ds.num.n; n=Ds.den.n; b=RR_poly(0); a=b;
            fac1=RR_poly([1 1]); fac2=RR_poly([1 -1]);
            for j=0:m; b=b+Ds.num.poly(m+1-j)*c^j*fac1^(n-j)*fac2^j; end
            for j=0:n; a=a+Ds.den.poly(n+1-j)*c^j*fac1^(n-j)*fac2^j; end, Dz=RR_tf(b,a); Dz.h=h;
        end % function RR_C2D_tustin

        function RR_impulse(G,g)
        % function RR_impulse(G,g)
        % Given a CT or DT plant G, defined as an RR_tf, plot the impulse response.
        % The (optional) derived type g groups together convenient parameters for plotting
        % (see RR_plot_response for details).
        % TEST: G=RR_tf([1],[1 0 0]), D=RR_tf(20*[1 1],[1 10]), close all, RR_impulse(G*D/(1+G*D))
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
            if nargin<2; g={}; end, RR_plot_response(G,-1,g); grid
        end % function RR_impulse

        function RR_step(G,g)
        % function RR_step(G,g)
        % Given a CT or DT plant G, defined as an RR_tf, plot the impulse response.
        % The (optional) derived type g groups together convenient parameters for plotting
        % (see RR_plot_response for details).
        % TEST: G=RR_tf([1],[1 0 0]), D=RR_tf(20*[1 1],[1 10]), close all, RR_step(G*D/(1+G*D))
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
            if nargin<2; g={}; end, RR_plot_response(G,0,g); grid
        end % function RR_step

        function [t,u,y]=RR_plot_response(G,m,g)
        % function [t,u,y]=RR_plot_response(G,m,g)
        % Using partial fraction expansions, compute and plot either:
        %   the response y(t) corresponding to Y(s)=G(s)*U(s) of a CT TF G(s) due to an input u(t), or
        %   the response y_k  corresponding to Y(z)=G(z)*U(z) of a CT TF G(z) due to an input u_k.
        % The CT input u(t), for t>=0, is a unit impulse for m=-1, a unit step for m=0, and u(t)=t^p for m>0, or
        % the DT input u_k,  for k>=0, is a unit impulse for m=-1, a unit step for m=0, and u_k =k^p for m>0.
        % The (optional) derived type g groups together convenient parameters for plotting:
        %   {g.T,g.N} define the interval and number of timesteps plotted in the CT case, and
        %   g.N       defines the number of timesteps plotted in the DT case,
        %   {g.linestyle_u,g.linestyle_y} are the linestyles used for the input u and the output y
        %   g.tol     defines the tolerance used when checking for repeated roots in the partial fraction expansion. 
        % Some convenient defaults are defined for each of these fields if they are not provided. You're welcome.
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
            if nargin<2, m=0; end, if nargin<3, g=[]; end      % Set up convenient defaults
            if isempty(G.h),                                   % some defaults for the CT case
                if ~isfield(g,'T'),             g.T=10;              end
                if ~isfield(g,'N'),             g.N=1000;            end
                if ~isfield(g,'linestyle_u'  ), g.linestyle_u='b-.'; end
                if ~isfield(g,'linestyle_y'  ), g.linestyle_y='r-';  end
            else               
                h=G.h;                                         % some defaults for the DT case
                if ~isfield(g,'N'),             g.N=50;              end
                if ~isfield(g,'linestyle_u'  ), g.linestyle_u='bo';  end
                if ~isfield(g,'linestyle_y'  ), g.linestyle_y='rx';  end
            end
            if     ~isfield(g,'tol'  ),         g.tol=1e-4;          end

            if isempty(G.h)  %%%%%%%%%%%%%  CT case  %%%%%%%%%%%%%
                m
                U=RR_tf(factorial(max(m,0)),[1 zeros(1,m+1)]);              % First, set up U(s)  
                [Up,Ud,Uk,Un]=RR_partial_fraction_expansion(U,g.tol);   % Then take the necessary
                [Yp,Yd,Yk,Yn]=RR_partial_fraction_expansion(G*U,g.tol); % partial fraction expansions
                h=g.T/g.N; t=[0:g.N]*h;
                for k=1:g.N+1
                    if m>=0, u(k)=real(sum(Ud.*t(k).^(Uk-1).*exp(Up*t(k)))); else, u(k)=0; end
                             y(k)=real(sum(Yd.*t(k).^(Yk-1).*exp(Yp*t(k))));
                end
            else             %%%%%%%%%%%%%  DT case  %%%%%%%%%%%%%    % First, set up R(z)
                if     m==-1, U=h^(-1)*RR_tf(1);                             % unit impulse
                elseif m==0 , U=RR_tf([1 0],[1 -1]);
                else,         U=h^m*RR_polylogarithm(m,1); end, U.h=h % (h*k)^m for m>=0
                N=g.N; k=[0:N]; t=k*h;
                [Ur,Ud,Up,Un]=RR_partial_fraction_expansion(U,g.tol),   u=zeros(1,N+1);
                [Yr,Yd,Yp,Yn]=RR_partial_fraction_expansion(G*U,g.tol), y=zeros(1,N+1);
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
        end % function RR_plot_response
    end
    methods(Access = protected)
        function displayScalarObject(G)
            % This function is used to print info about an RR_tf object G(s) or G(z) to the screen.
            fprintf(getHeader(G))
            fprintf('num:'), disp(G.num.poly)
            fprintf('den:'), disp(G.den.poly)
            if isempty(G.h), fprintf('Continuous-time transfer function\n'), else
                fprintf('Discrete-time transfer function with h='), disp(G.h), end
            nr=G.den.n-G.num.n;
            if nr>0, s='strictly proper'; elseif nr==0, s='semiproper'; else, s='improper'; end
            fprintf('  m=%d, n=%d, n_r=n-m=%d, %s, K=', G.num.n, G.den.n, nr, s), disp(G.K)
            fprintf('  z:'), disp(G.z)
            fprintf('  p:'), disp(G.p)
            if G.den.n==0, fprintf('\n'), end
        end
    end
end





