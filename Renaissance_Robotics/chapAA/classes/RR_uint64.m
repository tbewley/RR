% classdef RR_uint64
% This class implements a modified uint64 behavior with wrap on overflow, because Matlab don't wrap.
%
% Note that, as is standard, unsigned integer division and remainder are defined in RR such that
%   A = (A/B)*B + (A rem B) where (A rem B) has value less than the value of B.
% Unfortunately, as of April 2024, Matlab's built-in integer division,  A/B, doesn't conform to this
% standard, and thus should probably not be used when doing integer math, unless/until this is fixed.
% For example, taking the following in Matlab: [can also replace 64 with one of {8,16,32}]
%             b=uint64(7), a=uint64(4), q=b/a, r=rem(b,a)  gives  q=2, r=3.  (doah!)
% On the other hand, taking the following: [can also replace 64 with one of {8,16,32,128,256,512}]
%             B=RR_uint64(7), A=RR_uint64(4),  [Q,R]=B/A   gives  q=1, r=3.  :)
%
% DEFINITION:
%   A=RR_uint64(c) defines an RR_uint64 object from any integer 0<=c<=2^64-1=1.84e19
%
% STANDARD OPERATIONS defined on RR_uint64 objects
% (overloading the +, -, *, /, ^, <, >, <=, >=, ~=, == operators):
%   plus:     [SUM,CARRY]=A+B  gives the sum of two RR_uint64 integers
%   uminus:   -A gives the two's complement representation of negative A
%   minus:    B-A  gives the difference of two RR_uint64 integers (in two's complement form if negative)
%   mtimes:   [SUM,CARRY]=A*B  gives the product of two RR_uint64 integers
%   mrdivide: [QUO,REM]=B/A divides two  RR_uint64 integers, giving the quotient QUO and remainder REM
%   The relations <, >, <=, >=, ~=, == are also clearly defined.
%   {+,-,*,/} are all built on uint64 primatives
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

classdef RR_uint64 < matlab.mixin.CustomDisplay
    properties % Each RR_uint64 object consists of just one field:
        v      % a uint64 value (with +,-,*,/ redefined to wrap on overflow)
    end
    methods
        function OBJ = RR_uint64(v)         % Create an RR_uint64 object OBJ
            OBJ.v = uint64(abs(v)); if sign(v)==-1, OBJ=-OBJ; end
        end
        function [SUM,CARRY] = plus(A,B)    % Define A+B (ignore CARRY for wrap on overflow)
            [A,B]=check(A,B); [s,c]=RR_sum64(A.v,B.v); SUM=RR_uint64(s); CARRY=RR_uint64(c); 
        end
        function DIFF = minus(A,B)          % Define A-B
            [A,B]=check(A,B); Bbar=-B; DIFF=A+Bbar;
        end
        function OUT = uminus(B)            % Define -B
            [B]=check(B); OUT=RR_uint64(bitcmp(B.v)+1);
        end    
        function [PROD,CARRY] = mtimes(A,B) % Define A*B (ignore CARRY for wrap on overflow)
            [A,B]=check(A,B); [p,c]=RR_prod64(A.v,B.v); PROD=RR_uint64(p); CARRY=RR_uint64(c);
        end
        function [QUO,RE] = mrdivide(B,A)   % Define [QUO,RE]=B/A  Note: use idivide, not /
            [A,B]=check(A,B); QUO=RR_uint64(idivide(B.v,A.v)); RE=RR_uint64(rem(B.v,A.v));
        end
        function POW = mpower(A,n),  POW=A; for i=2:n; POW=POW*A; end, end    
        function FAC = factorial(A), FAC=RR_uint64(1); for i=2:A.v, FAC=FAC*i; end, end
        function n = norm(A), n=abs(A.v); end    % Defines norm(A)

        % Now define A<B, A>B, A<=B, A>=B, A~=B, A==B based on the values of A and B.
        function tf=lt(A,B), [A,B]=check(A,B); if A.v< B.v, tf=true; else, tf=false; end, end            
        function tf=gt(A,B), [A,B]=check(A,B); if A.v> B.v, tf=true; else, tf=false; end, end
        function tf=le(A,B), [A,B]=check(A,B); if A.v<=B.v, tf=true; else, tf=false; end, end
        function tf=ge(A,B), [A,B]=check(A,B); if A.v>=B.v, tf=true; else, tf=false; end, end
        function tf=ne(A,B), [A,B]=check(A,B); if A.v~=B.v, tf=true; else, tf=false; end, end
        function tf=eq(A,B), [A,B]=check(A,B); if A.v==B.v, tf=true; else, tf=false; end, end
        function [A,B]=check(A,B)
            if ~isa(A,'RR_uint64'), A=RR_uint64(A); end
            if nargin==2 & ~isa(B,'RR_uint64'), B=RR_uint64(B); end
        end

    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods(Access = protected)
        function displayScalarObject(obj)
            fprintf(getHeader(obj))
            disp(obj.v)
        end
    end
end

% cheatsheet: bitwise operations on unsigned integers, in both C and Matlab
%  C  Bit Operations   Matlab
% ------------------------------
% a>>k  rightshift   bitsrl(a,k)
% a<<k  leftshift    bitsll(a,k)
% a&b      AND       bitand(a,b)
% a^b      XOR       bitxor(a,b)
% a|b      OR        bitor(a,b)
% -a     2's comp.   bitcmp(a)
