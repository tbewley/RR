% classdef RR_ss
% This class defines a set of operations on state-space forms, each given by a set of 
% {A,B,C,D} matrices.
% In contrast to the Matlab 'ss' command, the RR_ss class definition can robustly handle
% a mixture of numeric and symbolic data.
%
% DEFINITION:
%   G=RR_ss(A)                 1 argument  defines G from A, taking B=C=D=0
%   G=RR_ss(A,B) or RR_ss(A,C) 2 arguments defines G from A, and B or C (whichever fits)
%   G=RR_ss(A,B,C)             3 arguments defines G from (A,B,C), taking D=0
%   G=RR_ss(A,B,C,D)           4 arguments defines G from (A,B,C,D), taking D=0
%   Note that an error is thrown if the dimensions don't fit correctly.
%   To generate a DT state-space form, use 1 of the above 4 commands, then set G.h
%   TEST: G=RR_ss(rand(3),rand(3,2),rand(1,3))
%
% STANDARD OPERATIONS defined on RR_ss objects (overloading the +, -, *, /, ^ operators):
%   plus:     G1+G2  gives the sum of two state-space forms        
%   minus:    G1-G2  gives the difference of two state-space forms 
%   mtimes:   G1*G2  gives the product of two state-space forms    
%   rdivide:  G1/G2  divides (??) two state-space forms
%   mpower:   G1^n   gives the n'th power of a state-space form
%
% ADDITIONAL OPERATIONS defined on RR_ss objects (try "help RR_ss/RR_*" for more info on any of them)
%   RR_impulse: Plots the impulse response of a CT plant G(s) or a DT plant G(z).
%   RR_step:    Plots the step    response of a CT plant G(s) or a DT plant G(z).
%   RR_plot_response: General algorithm for plotting system responce (using partial fraction expansions)
%%
% Renaissance Robotics codebase, Appendix A, https://github.com/tbewley/RR
% Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 

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
    end
    methods
    	function G = RR_ss(A,B,C,D)
        % function G = RR_ss(A,B,C,D)
        % Generates a CT or DT RR_ss object.
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License.
            [n,n1]=size(A); if nargin==1; B=zeros(n,1); end
            [n2,ni]=size(B); % Check inputs and create B,C,D as needed.
            if nargin<=2; if n2==n, no=1; n3=n; C=zeros(no,n); D=zeros(no,ni);
            else no=n2; n2=n; n3=n; ni=1; C=B; B=zeros(n,ni); end, else, [no,n3]=size(C); end
            if nargin<4, D=zeros(no,ni); no1=no; ni1=ni; else, [no1,ni1]=size(D); end
            if (n~=n1 | n1~=n2 | n2~=n3 | ni~=ni1 | no~=no1 ), error('Invalid input to RR_ss.'), end
            G.n=n; G.ni=ni; G.no=no; G.A=A; G.B=B; G.C=C; G.D=D; G.h=[];
    	end
    	function sum = plus(G1,G2)          
        % function sum = plus(G1,G2)          
        % Defines G1+G2, where G1 and G2 are of class RR_ss
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License.
            sum  = RR_ss(trim(G1.num*(G2.den/g)+G2.num*(G1.den/g)),trim(G1.den*(G2.den/g)));
            if ~isempty(G1.h); sum.h=G1.h; end
        end
        function diff = minus(G1,G2)       
        % function diff = minus(G1,G2)       
        % Defines G1-G2, where G1 and/or G2 are of class RR_ss
        % If G1 or G2 is a scalar, vector, or of class RR_poly, it is first converted to class RR_ss   
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
            [G1,G2]=check(G1,G2);  g=RR_gcd(G1.den,G2.den);  % (Dividing out the gcd improves accuracy)
            diff = RR_ss(G1.num*(G2.den/g)-G2.num*(G1.den/g),G1.den*(G2.den/g));
            if ~isempty(G1.h); diff.h=G1.h; end
        end    
        function prod = mtimes(G1,G2)       
        % function prod = mtimes(G1,G2)       
        % Defines G1*G2, where G1 and/or G2 are of class RR_ss
        % If G1 or G2 is a scalar, vector, or of class RR_poly, it is first converted to class RR_ss   
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
            [G1,G2]=check(G1,G2);
            prod = RR_ss(G1.num*G2.num,G1.den*G2.den);
            if ~isempty(G1.h); prod.h=G1.h; end
        end
        function quo = mrdivide(G1,G2)
        % function quo = mrdivide(G1,G2)
        % Defines G1/G2, where G1 and/or G2 are of class RR_ss
        % If G1 or G2 is a scalar, vector, or of class RR_poly, it is first converted to class RR_ss   
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
            [G1,G2]=check(G1,G2); quo  = RR_ss(G1.num*G2.den,G1.den*G2.num);
            if ~isempty(G1.h); quo.h=G1.h; end
        end
        function pow = mpower(G,n)
        % function pow = mpower(G,n)
        % Defines G^n, where G is of class RR_ss
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License.
             if n==0, pow=RR_ss([1]); else, pow=G; for i=2:n, pow=pow*G; end, end
            if ~isempty(G.h); pow.h=G.h; end
        end
        function [G1,G2]=check(G1,G2)
        % function [G1,G2]=check(G1,G2)
        % Converts G1 or G2, as necessary, to the class RR_ss
        % NOTE: this routine is just used internally in this class definition.
        % Renaissance Robotics codebase, Chapter 9, https://github.com/tbewley/RR
        % Copyright 2023 by Thomas Bewley, distributed under BSD 3-Clause License. 
            if ~isa(G1,'RR_ss'), G1=RR_ss(G1); if ~isempty(G2.h), G1.h=G2.h; end, end
            if ~isa(G2,'RR_ss'), G2=RR_ss(G2); if ~isempty(G1.h), G2.h=G1.h; end, end
            if     ~isempty(G1.h) & ~isempty(G2.h) & G1.h==G2.h, % disp 'valid DT TF operation'
            elseif  isempty(G1.h) &  isempty(G2.h),              % disp 'valid CT TF operation'
            else    error('Incompatible operation on state-space forms!')
            end
        end
    end
    methods(Access = protected)
        function displayScalarObject(G)
            % This function is used to print info about a CT or DT RR_ss object to the screen.
            fprintf(getHeader(G));
            m=max(8,floor(log10(max(max([G.A G.B; G.C G.D]))))+5); F=sprintf(' %% %d.%df',m,9);
            for i=1:G.n, t='';
              for j=1:G.n,  s=sprintf(F,G.A(i,j)); t=strcat(t,s(1:m)); end, t=strcat(t,' |');
              for j=1:G.ni, s=sprintf(F,G.B(i,j)); t=strcat(t,s(1:m)); end, disp(t)
            end, t=''; for i=1:m*G.n+3+m*G.ni, t=strcat(t,'-'); end, disp(t)
            for i=1:G.no, t='';
              for j=1:G.n,  s=sprintf(F,G.C(i,j)); t=strcat(t,s(1:m)); end, t=strcat(t,' |');
              for j=1:G.ni, s=sprintf(F,G.D(i,j)); t=strcat(t,s(1:m)); end, disp(t)
            end  
            if isempty(G.h), fprintf('Continuous-time state-space form\n'), else
                fprintf('Discrete-time state-space form, timestep='), disp(G.h), end
            ci=''; co=''; c='';
            if G.ni>1, ci='s'; end, if G.no>1, co='s'; end, if G.n>1, c='s'; end
            fprintf('with %d input%s, %d output%s, and %d state%s\n', G.ni,ci,G.no,co,G.n,c)
            if G.n<=9
               fprintf('Eigenvalues of system matrix A:\n'), disp(sort(eig(G.A)))
            end
        end
    end
end





