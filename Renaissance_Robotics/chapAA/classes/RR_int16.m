% classdef RR_int16
% An 16-bit signed integer class, built internally with int32 math, with flag on overflow, and an
% output that is RR_int16 if result fits in 16 bits, and grows into RR_int32 if it doesn't.
% Thus the following behavior (unlike Matlab's built-in functions):
%   A=RR_int16(32766), B=RR_int16(1), C=A+B % gives C=32767 (as RR_int16), overflow=false
%   A=RR_int16(32766), B=RR_int16(1), C=A+B % gives C=32768 (as RR_int32), overflow=true
%   A=RR_int16(100), B=RR_int16(-300), C=A*B % gives C=-30000 (as RR_int16),  overflow=false
%   A=RR_int16(100), B=RR_int16(-400), C=A*B % gives C=-40000 (as RR_int32), overflow=true
%
% RR defines signed integer division and remainder (unlike Matlab's built-in / operator)
% such that  B = (B/A)*A + R where the remainder R has value less than the value of B.  
% Thus the following behavior:
%   B=RR_randi8, A=RR_randi8(50), [Q,R]=B/A, C=(Q*A+R)-B   % gives C=0.
%
% DEFINITION:
%   A=RR_uint8(c)  defines an RR_uint16 object from any integer 0<=c<256=2^8=0xFF
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

classdef RR_int16 < matlab.mixin.CustomDisplay
    properties % Each RR_int16 object consists of just one field:
        v      % a int16 value (with +,-,*,/ redefined to wrap on overflow)
    end
    methods
        function OBJ = RR_int16(v)           % Create an RR_int8 object OBJ
            if v<-32767 | 32767<v, error('input out of range for RR_int16'),else, OBJ.v = int16(v); end
        end
        function [SUM,overflow] = plus(A,B) % Define A+B
            [A,B]=check(A,B); SUM=int32(A.v)+int32(B.v);  % Note: intermediate math is int32
            if -32768<=SUM & SUM<=32767, SUM=RR_int16(bitand(SUM,0xFFFFs32)); overflow=false; 
            else, warning('sum overflow in RR_int16, increasing int type to RR_uint32.');
                SUM=RR_int32(SUM); overflow=true, end
        end
        function DIFF = minus(A,B)          % Define A-B
            [A,B]=check(A,B); Bbar=-B; DIFF=A+Bbar;
        end
        function B = uminus(B)              % Define -B
            [B]=check(B); B.v=-B.v;
        end    
        function [PROD,CARRY] = mtimes(A,B) % Define A*B (ignore CARRY for wrap on overflow)
            [A,B]=check(A,B); t=uint16(A.v)*uint16(B.v);  % Note: intermediate math is uint16
            PROD=RR_uint8(bitand(t,0xFFu16)); CARRY=RR_uint8(bitsrl(t,8));
        end
        function [QUO,RE] = mrdivide(B,A)   % Define [QUO,RE]=B/A  Note: use idivide, not /
            [A,B]=check(A,B); QUO=RR_uint8(idivide(B.v,A.v)); RE=RR_uint8(rem(B.v,A.v));
        end
        function POW = mpower(A,n),   p=uint64(A.v)^n;
            if p==0xFFFFFFFFFFFFFFFF, error('Overflow'), end, POW=RR_uint8(bitand(p,0xFFu64)); end    
        function FAC = factorial(A), f=uint64(1);      for i=2:A.v, f=f*uint64(i); end
            if f==0xFFFFFFFFFFFFFFFF, error('Overflow'), end, FAC=RR_uint8(bitand(f,0xFFu64)); end
        function n = norm(A), n=abs(A.v); end    % Defines norm(A)          

        % Now define A<B, A>B, A<=B, A>=B, A~=B, A==B based on the values of A and B.
        function tf=lt(A,B), [A,B]=check(A,B); if A.v< B.v, tf=true; else, tf=false; end, end            
        function tf=gt(A,B), [A,B]=check(A,B); if A.v> B.v, tf=true; else, tf=false; end, end
        function tf=le(A,B), [A,B]=check(A,B); if A.v<=B.v, tf=true; else, tf=false; end, end
        function tf=ge(A,B), [A,B]=check(A,B); if A.v>=B.v, tf=true; else, tf=false; end, end
        function tf=ne(A,B), [A,B]=check(A,B); if A.v~=B.v, tf=true; else, tf=false; end, end
        function tf=eq(A,B), [A,B]=check(A,B); if A.v==B.v, tf=true; else, tf=false; end, end
        function s=sign(A),                    if A.v==0,   s=0;     else, s=1;      end, end
        function [A,B]=check(A,B)
            if ~isa(A,'RR_int16'), A=RR_int16(A); end
            if nargin==2 & ~isa(B,'RR_int16'), B=RR_int16(B); end
        end

    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods(Access = protected)
        function displayScalarObject(OBJ)
            fprintf('RR_int16 with value 0x%s = %i\n',dec2hex(OBJ.v,4),OBJ.v)
        end
    end
end