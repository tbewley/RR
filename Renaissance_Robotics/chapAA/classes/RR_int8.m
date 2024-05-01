% classdef RR_int8
% An 8-bit signed integer class, built internally with int16 math, with both a warning on overflow,
% and an output that is RR_int8 if result fits in 8 bits, and expands into RR_int16 if it doesn't.
% Thus the following (admittedly nonstandard) behavior (unlike Matlab's built-in functions):
%   A=RR_int8(2^7-2), B=RR_int8(1),  [C,overflow]=A+B % gives C=127  (as RR_int8),  overflow=false
%   A=RR_int8(2^7-2), B=RR_int8(2),  [C,overflow]=A+B % gives C=128  (as RR_int16), overflow=true
%   A=RR_int8(2^6),   B=RR_int8(-1), [C,overflow]=A*B % gives C=-64  (as RR_int8),  overflow=false
%   A=RR_int8(2^6),   B=RR_int8(-3), [C,overflow]=A*B % gives C=-192 (as RR_int16), overflow=true
% Hey, at least the results are correct.  Try the following to watch it in action:
%   A=RR_int8(1); for i=2:21, A=A*i, end
%
% Note that RR defines signed integer division and remainder (unlike Matlab's built-in / operator)
% such that  A = (A/B)*B + R where sign(R)=sign(A) and |R|<|B|, where A=dividend, B=divisor.
% Signed integer division in RR satisfies the identity (−A)/B = −(A/B) = A/(−B).
% Thus, the following calculations give C=0, sign(R)=sign(A), |R|<|B|, and Q1=Q2=Q3:
%   A=RR_rand_RR_int([-128,127]), B=RR_rand_RR_int([-30,30])
%   if B~=0, [Q,R]=A/B, C=(Q*B+R)-A, Q1=(-A)/B, Q2=-(A/B), Q3=A/(-B), end 
%
% DEFINITION:
%   A=RR_uint8(c)  defines an RR_uint8 object from any integer 0<=c<256=2^8=0xFF
%
% STANDARD OPERATIONS defined on RR_uint8 objects
% (overloading the +, -, *, /, ^, <, >, <=, >=, ~=, == operators):
%   plus:     [SUM,CARRY]=A+B  gives the sum of two RR_uint8 integers
%   uminus:   -A gives the two's complement representation of negative A
%   minus:    B-A  gives the difference of two RR_uint8 integers (in two's complement form if negative)
%   mtimes:   [SUM,CARRY]=A*B  gives the product of two RR_uint8 integers
%   mrdivide: [QUO,REM]=B/A divides two  RR_uint8 integers, giving the quotient QUO and remainder REM
%   The relations <, >, <=, >=, ~=, == are also clearly defined.
%   {+,-,*,/} are built on uint16 and uint8 primatives
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

classdef RR_int8 < matlab.mixin.CustomDisplay
    properties % Each RR_int8 object consists of just one field:
        v      % a int8 value (with +,-,*,/ redefined to wrap on overflow)
    end
    methods
        function OBJ = RR_int8(v)           % Create an RR_int8 object OBJ
            if v<-128 | 127<v, error('input out of range for RR_int8'), else, OBJ.v = int8(v); end
        end
        function [SUM,overflow] = plus(A,B) % Define A+B
            A=RR_int8.check(A); B=RR_int8.check(B); s=int16(A.v)+int16(B.v);
            if s==int8(s), SUM=RR_int8(s); overflow=false; 
            else, warning('sum overflow in RR_int8, increasing int type to RR_int16.');
                SUM=RR_int16(s); overflow=true; end
        end
        function [DIFF,overflow] = minus(A,B)          % Define A-B
            A=RR_int8.check(A); B=RR_int8.check(B); Bbar=-B; [DIFF,overflow]=A+Bbar;
        end
        function OUT = uminus(B)            % Define -B
            B=RR_int8.check(B); OUT=RR_int8(-B.v);
        end    
        function [PROD,overflow] = mtimes(A,B) % Define A*B
            A=RR_int8.check(A); B=RR_int8.check(B);
            p=int16(A.v)*int16(B.v);
            if p==int8(p), PROD=RR_int8(p); overflow=false; 
            else, warning('product overflow in RR_int8, increasing int type to RR_int16.');
                PROD=RR_int16(p); overflow=true; end
        end
        function [QUO,RE] = mrdivide(A,B)   % Define [QUO,RE]=A/B  Note: use idivide, not /
            A=RR_int8.check(A); B=RR_int8.check(B);
            QUO=RR_int8(idivide(A.v,B.v)); RE=RR_int8(rem(A.v,B.v));
        end
        function n = norm(A), n=abs(A.v); end    % Defines norm(A)          

        % Now define A<B, A>B, A<=B, A>=B, A~=B, A==B based on the values of A and B.
        function tf=lt(A,B), A=RR_int8.check(A); B=RR_int8.check(B);
                             if A.v< B.v, tf=true; else, tf=false; end, end            
        function tf=gt(A,B), A=RR_int8.check(A); B=RR_int8.check(B);
                             if A.v> B.v, tf=true; else, tf=false; end, end
        function tf=le(A,B), A=RR_int8.check(A); B=RR_int8.check(B);
                             if A.v<=B.v, tf=true; else, tf=false; end, end
        function tf=ge(A,B), A=RR_int8.check(A); B=RR_int8.check(B);
                             if A.v>=B.v, tf=true; else, tf=false; end, end
        function tf=ne(A,B), A=RR_int8.check(A); B=RR_int8.check(B);
                             if A.v~=B.v, tf=true; else, tf=false; end, end
        function tf=eq(A,B), A=RR_int8.check(A); B=RR_int8.check(B);
                             if A.v==B.v, tf=true; else, tf=false; end, end
        function s=sign(A),  if A.v==0,   s=0;     else, s=1;      end, end
    end
    methods(Static)
        function A=check(A)
            if isa(A,'numeric'), A=RR_int8(A);
            elseif ~isa(A,'RR_uint8'), A=RR_int8(A.v); end
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods(Access = protected)
        function displayScalarObject(OBJ)
            fprintf('RR_int8 with value 0x%s = %i\n',dec2hex(OBJ.v,2),OBJ.v)
        end
    end
end