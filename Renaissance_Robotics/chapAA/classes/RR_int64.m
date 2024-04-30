% classdef RR_int64
% A 64-bit signed integer class, built internally with uint64 math, with error on overflow.
% Thus the following behavior (unlike Matlab's built-in functions):
%   A=RR_int64(4*10^18), B=RR_int64(-2), C=A*B  % gives C=-8*10^18 (as RR_int64)
%   A=RR_int64(4*10^18), B=RR_int64(-3), C=A*B  % throws an error
% Hey, at least the results (when an error isn't thrown) are correct...
%
% Note that RR defines signed integer division and remainder (unlike Matlab's built-in / operator)
% such that  A = (A/B)*B + R where sign(R)=sign(A) and |R|<|B|, where A=dividend, B=divisor.
% Signed integer division in RR satisfies the identity (−A)/B = −(A/B) = A/(−B).
% Thus, the following calculations give C=0, |R|<|B|, sign(R)=sign(A), and Q1=Q2=Q3:
%   A=RR_rand_RR_int([-10^16,10^16]), B=RR_rand_RR_int([-10^10,10^10])
%   if B~=0, [Q,R]=A/B, C=(Q*B+R)-A, Q1=(-A)/B, Q2=-(A/B), Q3=A/(-B), end 
%
% DEFINITION:
%   A=RR_int32(c)  defines an RR_int32 object from any integer 0<=c<256=2^8=0xFF
%
% STANDARD OPERATIONS defined on RR_int32 objects
% (overloading the +, -, *, /, ^, <, >, <=, >=, ~=, == operators):
%   plus:     [SUM,CARRY]=A+B  gives the sum of two RR_int32 integers
%   uminus:   -A gives the two's complement representation of negative A
%   minus:    B-A  gives the difference of two RR_int32 integers (in two's complement form if negative)
%   mtimes:   [SUM,CARRY]=A*B  gives the product of two RR_int32 integers
%   mrdivide: [QUO,REM]=B/A divides two  RR_int32 integers, giving the quotient QUO and remainder REM
%   The relations <, >, <=, >=, ~=, == are also clearly defined.
%   {+,-,*,/} are built on int64 primatives
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

classdef (InferiorClasses = {?RR_int8, ?RR_int16, ?RR_int32}) RR_int64 < matlab.mixin.CustomDisplay
    properties % Each RR_int64 object consists of just one field:
        v      % an int64 value (with +,-,*,/ redefined to wrap on overflow)
    end
    methods
        function OBJ = RR_int64(v)           % Create an RR_int64 object OBJ
            OBJ.v = int64(v);
        end
        function SUM = plus(A,B) % Define A+B
            A=RR_int64.check(A); B=RR_int64.check(B); s=A.v+B.v; SUM=RR_int64(s);
            if s-A.v~=B.v, error('sum overflow in RR_int64.'); end
        end
        function DIFF = minus(A,B)          % Define A-B
            A=RR_int64.check(A); B=RR_int64.check(B); Bbar=-B; DIFF=A+Bbar;
        end
        function B = uminus(B)              % Define -B
            B=RR_int64.check(B); B.v=-B.v;
        end    
        function PROD = mtimes(A,B) % Define A*B (ignore CARRY for wrap on overflow)
            A=RR_int64.check(A); B=RR_int64.check(B); p=A.v*B.v; PROD=RR_int64(p);
            if idivide(p,A.v)~=B.v, error('product overflow in RR_int64.'); end
        end
        function [QUO,RE] = mrdivide(A,B)   % Define [QUO,RE]=A/B  Note: use idivide, not /
            A=RR_int64.check(A); B=RR_int64.check(B);
            QUO=RR_int64(idivide(A.v,B.v)); RE=RR_int64(rem(A.v,B.v));
        end
        function n = norm(A), n=abs(A.v); end    % Defines norm(A)          

        % Now define A<B, A>B, A<=B, A>=B, A~=B, A==B based on the values of A and B.
        function tf=lt(A,B), A=RR_int64.check(A); B=RR_int64.check(B);
                             if A.v< B.v, tf=true; else, tf=false; end, end            
        function tf=gt(A,B), A=RR_int64.check(A); B=RR_int64.check(B);
                             if A.v> B.v, tf=true; else, tf=false; end, end
        function tf=le(A,B), A=RR_int64.check(A); B=RR_int64.check(B);
                             if A.v<=B.v, tf=true; else, tf=false; end, end
        function tf=ge(A,B), A=RR_int64.check(A); B=RR_int64.check(B);
                             if A.v>=B.v, tf=true; else, tf=false; end, end
        function tf=ne(A,B), A=RR_int64.check(A); B=RR_int64.check(B);
                             if A.v~=B.v, tf=true; else, tf=false; end, end
        function tf=eq(A,B), A=RR_int64.check(A); B=RR_int64.check(B);
                             if A.v==B.v, tf=true; else, tf=false; end, end
        function s=sign(A),  if A.v==0,   s=0;     else, s=1;      end, end
    end
    methods(Static)
        function A=check(A)
            if isa(A,'numeric'), A=RR_int64(A);
            elseif ~isa(A,'RR_int64'), A=RR_int64(A.v); end
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods(Access = protected)
        function displayScalarObject(OBJ)
            fprintf('RR_int64 with value 0x%s = %i\n',dec2hex(OBJ.v,16),OBJ.v)
        end
    end
end