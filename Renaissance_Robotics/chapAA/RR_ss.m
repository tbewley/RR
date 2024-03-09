% classdef RR_ss
% This class defines a set of operations on state-space forms, each given by a set of 
% {A,B,C,D} matrices.
% In contrast to the Matlab 'ss' command, the RR_ss class definition can robustly handle
% a mixture of numeric and symbolic data.
%
% DEFINITION:
%   G=RR_ss(D)                 1 argument  defines G from D (i.e., static gain, w/ A=B=C=0)
%   G=RR_ss(A,B) or RR_ss(A,C) 2 arguments defines G from A and B (or C, if it fits better)
%   G=RR_ss(A,B,C)             3 arguments defines G from (A,B,C), taking D=0, or
%   G=RR_ss(A,B,C,D)           4 arguments defines G from (A,B,C,D)
%                              [You can set D=0 to mean the zero matrix of appropriate size.]
%   Note that an error is thrown if the dimensions don't fit correctly.
%   To generate a DT state-space form, use 1 of the above 4 commands, then set G.h
%   If the sample time is undetermined, do the following:  syms h, G.h=h
%   TEST: G=RR_ss(rand(3),rand(3,2),rand(1,3)); G.h=0.1
%
% STANDARD OPERATIONS defined on RR_ss objects (overloading the +, -, *, /, ^ operators):
%   plus:     G1+G2  gives the sum of two state-space forms (parallel connection)       
%   minus:    G1-G2  gives the difference of two state-space forms 
%   mtimes:   G1*G2  gives the product of two state-space forms (series connection)
%   rdivide:  G1/G2  divides two state-space forms (???)
%   mpower:   G1^n   gives the n'th power of a state-space form
%
% ADDITIONAL OPERATIONS defined on RR_ss objects (try "help RR_ss/RR_*" for more info on any of them)
%   RR_impulse: Plots the impulse response of a CT or DT plant G.
%   RR_step:    Plots the step    response of a CT or DT plant G.
%   RR_plot_response: General algorithm for plotting system responce
%
%% Renaissance Repository, https://github.com/tbewley/RR/tree/main/Renaissance_Robotics/RR_chapAA
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

classdef RR_ss < matlab.mixin.CustomDisplay
    properties
    	A    % matrices {A,B,C,D} define the ss form (each may be symbolic!) 
    	B
        C
        D
        n    % number of states
        ni   % number of inputs
        no   % number of outputs
        h    % h=timestep for DT ss representations only (empty for CT ss representations)
        s    % logical indicating some symbolic elements in {A,B,C,D}
    end
    methods
    	function G = RR_ss(A,B,C,D)
        % function G = RR_ss(A,B,C,D)
        % Generates a CT or DT RR_ss object.
            [n,n1]=size(A);
            if nargin==1, G.D=A; [G.no,G.ni]=size(G.D); G.n=0;
                   G.A=zeros(G.n,G.n); G.B=zeros(G.n,G.ni); G.C=zeros(G.no,G.n);                              
            else,
              [n2,ni]=size(B); % Check inputs and create B,C,D as needed.
              if nargin==2; if n2==n, no=1; n3=n; C=zeros(no,n); D=zeros(no,ni);
                            else no=n2; n2=n; n3=n; ni=1; C=B; B=zeros(n,ni); end
              else, [no,n3]=size(C); end
              if nargin<4 | (isnumeric(D) & D==0), D=zeros(no,ni); no1=no; ni1=ni; else, [no1,ni1]=size(D); end
              if (n~=n1 | n~=n2 | n~=n3 | ni~=ni1 | no~=no1 ),
                 error('Invalid input to RR_ss.'), end
              G.n=n; G.ni=ni; G.no=no; G.A=A; G.B=B; G.C=C; G.D=D; G.h=[];
            end
            G.s=~(isnumeric(G.A) & isnumeric(G.B) & isnumeric(G.C) & isnumeric(G.D));
    	end
    	function sum = plus(G1,G2)          
        % function sum = plus(G1,G2)          
        % Defines G1+G2, where G1 and G2 are of class RR_ss
            [G1,G2]=check(G1,G2);
            if (~(G1.n*G2.n==0 & (G1.no==G2.no & G1.no==G2.no))... 
               &(G1.n~=G2.n|G1.ni~=G2.ni|G1.no~=G2.no)), error('Dimensions incorrect'), end
            if (isempty(G1.h)+isempty(G2.h)==1), error('Both ss forms must be CT or DT'), end
            A=[G1.A, zeros(G1.n,G2.n); zeros(G2.n,G1.n) G2.A];
            B=[G1.B; G2.B]; C=[G1.C, G2.C]; D=G1.D+G2.D; sum=RR_ss(A,B,C,D);
            if ~isempty(G1.h)
              if G1.h~=G2.h, error('Sample times of DT forms do not match'),
              else, sum.h=G1.h; end
            end
            sum.s=G1.s|G2.s;
        end
        function diff = minus(G1,G2)       
        % function diff = minus(G1,G2)       
        % Defines G1-G2, where G1 and/or G2 are of class RR_ss
            [G1,G2]=check(G1,G2); G2.C=-G2.C; G2.D=-G2.D; diff=plus(G1,G2);
        end
        function Gm = uminus(G)
        % function Gm = uminus(G)
            Gm=RR_ss(G.A,G.B,-G.C,-G.D);
        end
        function prod = mtimes(G,D)       
        % function prod = mtimes(G,D)       
        % Defines G*D, where G and/or D are of class RR_ss
        % This means that the output of D (e.g., controller) forms the input of G (e.g., plant)
            [G,D]=check(G,D);
            Ao=[G.A G.B*D.C; zeros(D.n,G.n) D.A]; Bo=[G.B*D.D; D.B];
            Co=[G.C G.D*D.C];                     Do=[G.D*D.D];    prod=RR_ss(Ao,Bo,Co,Do);
            if (isempty(G.h)+isempty(D.h)==1), error('Both ss forms must be CT or DT'), end
            if ~isempty(G.h)
              if G.h~=D.h, error('Sample times of DT forms do not match'),
              else, prod.h=G.h; end
            end
            prod.s=G.s|D.s;
        end
        function sol = mldivide(G1,G2)
        % function sol = mrdivide(G1,G2)
        % Defines G1\G2=inv(G1)*G2, where G1 and/or G2 are of class RR_ss
        % If G1 or G2 is a scalar, vector, or of class RR_poly, it is first converted to class RR_ss   
            [G1,G2]=check(G1,G2);
            if (isempty(G1.h)+isempty(G2.h)==1), error('Both ss forms must be CT or DT'), end
            if ~isempty(G1.h)
              if G1.h~=G2.h, error('Sample times of DT forms do not match'),
              else, sol.h=G2.h; end
            end
            sol=inv(G1)*G2;
            sol.s=G1.s|G2.s;
        end
        function inverse = inv(G)
        % function inverse = inv(G)
        % Defines the inverse of G, of class RR_ss, assuming D is square and invertible
            if G.ni~=G.no, error('SS inverse only implemented for ni=no'), end
            A=G.A; B=G.B; C=G.C; Di=inv(G.D); inverse=RR_ss(A-B*Di*C,B*Di,-Di*C,Di);
            if ~isempty(G.h); inverse.h=G.h; end, inverse.s=G.s;
        end
        function pow = mpower(G,n)
        % function pow = mpower(G,n)
        % Defines G^n for integer n, where G is of class RR_ss
            if n==0, pow=RR_ss([1]); elseif n>0, pow=G; else, pow=inv(G); end
            for i=2:abs(n), pow=pow*G; end
            if ~isempty(G.h); pow.h=G.h; end
        end
        function [a,b]=check(a,b)
        % function [a,b]=check(a,b)
        % Converts a or b, as necessary, to the class RR_ss
        % NOTE: this routine is just used internally in this class definition.
            if     ~isa(a,'RR_ss')
                if length(a)==1, a=RR_ss(a*eye(b.no));
                    if b.no~=b.ni, error('Can only add a scalar if ni=no'), end
                else,            a=RR_ss(a); end
            elseif ~isa(b,'RR_ss')
                if length(b)==1, b=RR_ss(b*eye(a.no));
                    if a.no~=a.ni, error('Can only add a scalar if ni=no'), end
                else,            b=RR_ss(b); end
            end
        end
        function GR=transform(G,R)
        % function [GR]=transform(G,R)
        % Transform a state-space form G, of type RR_ss, with an invertible matrix R. 
           Ri=inv(R); GR=RR_ss(Ri*G.A*R,Ri*G.B,G.C*R,G.D);
           if ~isempty(G.h); GR.h=G.h; end
        end
        function GM=minreal(G)
           [A,B,C]=RR_SS2CanonicalForm(G.A,G.B,G.C,'Minimal');
           GM=RR_ss(A,B,C,G.D);
           if ~isempty(G.h); GR.h=G.h; end
        end
    end
    methods(Access = protected)
        function displayScalarObject(G)
            % This function is used to print info about a CT or DT RR_ss object to the screen.
            fprintf(getHeader(G)); test=[G.A G.B; G.C G.D]; b=" ";
            if isreal(test), r=true; else, r=false; end
            ci=''; co=''; c=''; if G.ni>1, ci='s'; end, if G.no>1, co='s'; end, if G.n>1, c='s'; end
            if G.n==0, fprintf('Static gain.  D=\n'), disp(G.D)
            elseif G.s~=0,
              if isempty(G.h), fprintf('CT state-space form with symbolic elements\n'), else
                fprintf('DT state-space form with symbolic elements and sample time= %g\n',G.h), end
              for i=1:G.n,  for j=1:G.n,  A(i,j)=string(sprintf('%s',G.A(i,j))); end
                            for j=1:G.ni, B(i,j)=string(sprintf('%s',G.B(i,j))); end, end
              for i=1:G.no, for j=1:G.n,  C(i,j)=string(sprintf('%s',G.C(i,j))); end
                            for j=1:G.ni, D(i,j)=string(sprintf('%s',G.D(i,j))); end, end
              disp('Warning: RR_ss in symbolic case assumes all individual matrix elements are scalars')
              l=max([max(max(strlength(A))),max(max(strlength(B))), ...
                     max(max(strlength(C))),max(max(strlength(D)))]);
              for i=1:G.n, t='';
                 for j=1:G.n,  t=strcat(t,pad(A(i,j),l,'both'),b); end, t=strcat(t,'|',b);
                 for j=1:G.ni, t=strcat(t,pad(B(i,j),l,'both'),b); end, disp(t)
              end, t=pad("",l*(G.n+G.ni)+3,'left','-'); disp(t)
              for i=1:G.no, t='';
                 for j=1:G.n,  t=strcat(t,pad(C(i,j),l,'both'),b); end, t=strcat(t,'|',b);
                 for j=1:G.ni, t=strcat(t,pad(D(i,j),l,'both'),b); end, disp(t)
              end
            else
              if isempty(G.h), fprintf('CT state-space form\n'), else
              fprintf('DT state-space form with sample time= %g\n',G.h), end
              for i=1:G.n, t='';
                if r 
                  for j=1:G.n,  s=format_real_entry(G.A(i,j)); t=strcat(t,s(1:10),b);
                  end, t=strcat(t,'|');
                  for j=1:G.ni, s=format_real_entry(G.B(i,j)); t=strcat(t,s(1:10),b);
                  end, disp(t)
                else 
                  for j=1:G.n,  s=format_complex_entry(G.A(i,j)); t=strcat(t,s(1:20),b);
                  end, t=strcat(t,'|');
                  for j=1:G.ni, s=format_complex_entry(G.B(i,j)); t=strcat(t,s(1:20),b);
                  end, disp(t)
                end 
              end, l=strlength(t); t=pad("",l,'left','-'); disp(t) 
              for i=1:G.no, t='';
                if r
                  for j=1:G.n,  s=format_real_entry(G.C(i,j)); t=strcat(t,s(1:10),b);
                  end, t=strcat(t,'|');
                  for j=1:G.ni, s=format_real_entry(G.D(i,j)); t=strcat(t,s(1:10),b);
                  end, disp(t)
                else 
                  for j=1:G.n,  s=format_complex_entry(G.C(i,j)); t=strcat(t,s(1:20),b);
                  end, t=strcat(t,'|');
                  for j=1:G.ni, s=format_complex_entry(G.D(i,j)); t=strcat(t,s(1:20),b);
                  end, disp(t)
                end
              end  
              fprintf('with %d input%s, %d output%s, and %d state%s,', G.ni,ci,G.no,co,G.n,c)
              if G.n>1 & G.n<=9
                if isempty(G.h),
                  e=sort(eig(G.A),'ComparisonMethod','real');
                  en=sum(real(e)>0); es=''; if en~=1, es='s'; end
                  fprintf(' and %d eigenvalue%s in RHP\n',en,es)
                  if en==0, fprintf('Eigenvalues of stable CT system matrix:\n'),
                  else,     fprintf('Eigenvalues of unstable CT system matrix:\n'), end
                  for i=1:G.n, if i>1, fprintf(', '), end
                    if isreal(e(i)), fprintf('%#.3g',e(i))
                    else,            fprintf('%#.3g%+#.3g*i',real(e(i)),imag(e(i))), end
                  end, disp(' ')
                else,
                  e=sort(eig(G.A),'ComparisonMethod','abs');
                  en=sum(abs(e)>1); es=''; if en~=1, es='s'; end
                  fprintf(' and %d eigenvalue%s outside unit circle\n',en,es)
                  if en==0, fprintf('Eigenvalues of stable DT system matrix:\n'),
                  else,     fprintf('Eigenvalues of unstable DT system matrix:\n'), end
                  for i=1:G.n, if i>1, fprintf(', '), end
                    if isreal(e(i)), fprintf('%#.3g',e(i))
                    else,            fprintf('%#.3g%+#.3g*i',real(e(i)),imag(e(i))), end
                  end, disp(' ')
                end
              end
            end
            function s = format_complex_entry(z)
               x=real(z); y=imag(z); amax=max(abs(x),abs(y));
               if (amax>=1e3 | amax<1e-2) & amax~=0, s=sprintf('%9.2e%+9.2e*i',x,y);
               else,                                 s=sprintf('%9.4f%+9.4f*i',x,y); end
            end
            function s = format_real_entry(z)
               amax=abs(z);
               if (amax>=1e3 | amax<1e-2) & amax~=0, s=sprintf(' %9.2e',z);
               else                                  s=sprintf(' %9.4f',z); end
            end
        end
    end
end





