% classdef RR_int32
% A 32-bit signed integer class, built internally with int64 math, with flag on overflow, and an
% output that is RR_int32 if result fits in 32 bits, and grows into RR_int64 if it doesn't.
% Thus the following behavior (unlike Matlab's built-in functions):
%   A=RR_int32(2^31-2), B=RR_int32(1),  C=A+B % gives C=2147483647 (as RR_int32), overflow=false
%   A=RR_int32(2^31-2), B=RR_int32(2),  C=A+B % gives C=2147483648 (as RR_int64), overflow=true
%   A=RR_int32(10^9),   B=RR_int32(-2), C=A*B % gives C=-2*10^9 (as RR_int32), overflow=false
%   A=RR_int32(10^9),   B=RR_int32(-3), C=A*B % gives C=-3*10^9 (as RR_int64), overflow=true
% Hey, at least the results are correct.  Try the following to watch it in action:
%   A=RR_int8(1); for i=2:21, A=A*i, end
%
% Note that RR defines signed integer division and remainder (unlike Matlab's built-in / operator)
% such that  A = (A/B)*B + R where sign(R)=sign(A) and |R|<|B|, where A=dividend, B=divisor.
% Signed integer division in RR satisfies the identity (−A)/B = −(A/B) = A/(−B).
% Thus, the following calculations give C=0, |R|<|B|, sign(R)=sign(A), and Q1=Q2=Q3:
%   A=RR_rand_RR_int([-2147483648,2147483647]), B=RR_rand_RR_int([-100000,100000])
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

classdef (InferiorClasses = {?RR_int8, ?RR_int16}) RR_int32 < matlab.mixin.CustomDisplay
    properties % Each RR_int32 object consists of just one field:
        v      % a int32 value (with +,-,*,/ redefined to wrap on overflow)
    end
    methods
        function OBJ = RR_int32(v)           % Create an RR_int32 object OBJ
            if v<-2147483648 | 2147483647<v, error('input out of range for RR_int32'),
            else, OBJ.v = int32(v); end
        end
        function [SUM,overflow] = plus(A,B) % Define A+B
            A=RR_int32.check(A); B=RR_int32.check(B); s=int64(A.v)+int64(B.v);
            if s==int32(s), SUM=RR_int32(s); overflow=false; 
            else, warning('sum overflow in RR_int32, increasing int type to RR_int64.');
                SUM=RR_int32(s); overflow=true; end
        end
        function DIFF = minus(A,B)          % Define A-B
            A=RR_int32.check(A); B=RR_int32.check(B); Bbar=-B; DIFF=A+Bbar;
        end
        function B = uminus(B)              % Define -B
            B=RR_int32.check(B); B.v=-B.v;
        end    
        function [PROD,overflow] = mtimes(A,B) % Define A*B (ignore CARRY for wrap on overflow)
            A=RR_int32.check(A); B=RR_int32.check(B); p=int64(A.v)*int64(B.v);
            if p==int32(p), PROD=RR_int32(p); overflow=false; 
            else, warning('product overflow in RR_int32, increasing int type to RR_int64.');
                PROD=RR_int64(p); overflow=true; end
        end
        function [QUO,RE] = mrdivide(A,B)   % Define [QUO,RE]=A/B  Note: use idivide, not /
            A=RR_int32.check(A); B=RR_int32.check(B);
            QUO=RR_int32(idivide(A.v,B.v)); RE=RR_int32(rem(A.v,B.v));
        end
        function n = norm(A), n=abs(A.v); end    % Defines norm(A)          

        % Now define A<B, A>B, A<=B, A>=B, A~=B, A==B based on the values of A and B.
        function tf=lt(A,B), A=RR_int32.check(A); B=RR_int32.check(B);
                             if A.v< B.v, tf=true; else, tf=false; end, end            
        function tf=gt(A,B), A=RR_int32.check(A); B=RR_int32.check(B);
                             if A.v> B.v, tf=true; else, tf=false; end, end
        function tf=le(A,B), A=RR_int32.check(A); B=RR_int32.check(B);
                             if A.v<=B.v, tf=true; else, tf=false; end, end
        function tf=ge(A,B), A=RR_int32.check(A); B=RR_int32.check(B);
                             if A.v>=B.v, tf=true; else, tf=false; end, end
        function tf=ne(A,B), A=RR_int32.check(A); B=RR_int32.check(B);
                             if A.v~=B.v, tf=true; else, tf=false; end, end
        function tf=eq(A,B), A=RR_int32.check(A); B=RR_int32.check(B);
                             if A.v==B.v, tf=true; else, tf=false; end, end
        function s=sign(A),  if A.v==0,   s=0;     else, s=1;      end, end
    end
    methods(Static)
        function A=check(A)
            if isa(A,'numeric'), A=RR_int32(A);
            elseif ~isa(A,'RR_int32'), A=RR_int32(A.v); end
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods(Access = protected)
        function displayScalarObject(OBJ)
            fprintf('RR_int32 with value 0x%s = %i\n',dec2hex(OBJ.v,8),OBJ.v)
        end
    end
end