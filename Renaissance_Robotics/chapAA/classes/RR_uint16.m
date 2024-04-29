% classdef RR_uint16
% A 16-bit unsigned integer class, built internally with uint32 math, with wrap on overflow/underflow
% using two's complement notation.  Thus the following behavior (unlike Matlab's built-in functions):
%   A=RR_rand_RR_uint(16), B=-A, C=A+B  % gives C=0 [can replace 16 with anything from 1 to 1024...]
%
% RR defines unsigned integer division and remainder (unlike Matlab's built-in / operator)
% such that  B = (B/A)*A + R where the remainder R has value less than the value of B.  
% Thus the following behavior:
%   B=RR_rand_RR_uint(16), A=RR_rand_RR_uint(10)+1, [Q,R]=B/A, C=(Q*A+R)-B   % gives C=0.
%
% DEFINITION:
%   A=RR_uint16(c) defines an RR_uint16 object from any integer 0<=c<=2^16-1=0xFFFF=65535
%
% STANDARD OPERATIONS defined on RR_uint16 objects
% (overloading the +, -, *, /, ^, <, >, <=, >=, ~=, == operators):
%   plus:     [SUM,CARRY]=A+B  gives the sum of two RR_uint16 integers
%   uminus:   -A gives the two's complement representation of negative A
%   minus:    B-A  gives the difference of two RR_uint16 integers (in two's complement form if negative)
%   mtimes:   [SUM,CARRY]=A*B  gives the product of two RR_uint16 integers
%   mrdivide: [QUO,REM]=B/A divides two  RR_uint16 integers, giving the quotient QUO and remainder REM
%   The relations <, >, <=, >=, ~=, == are also clearly defined.
%   {+,-,*,/} are all built on uint32 and uint16 primatives
%
%% Renaissance Repository, https://github.com/tbewley/RR (Renaissance Robotics, Appendix A)
%% Copyright 2024 by Thomas Bewley, published under BSD 3-Clause License. 

classdef (InferiorClasses = {?RR_uint8}) RR_uint16 < matlab.mixin.CustomDisplay
    properties % Each RR_uint16 object consists of just one field:
        v      % a uint16 value (with +,-,*,/ redefined to wrap on overflow)
    end
    methods
        function OBJ = RR_uint16(v)         % Create an RR_uint16 object OBJ
            OBJ.v = uint16(abs(v)); if sign(v)==-1, OBJ=-OBJ; end
        end
        function [SUM,CARRY] = plus(A,B)    % Define A+B (ignore CARRY for wrap on overflow)
            A=RR_uint16.check(A); B=RR_uint16.check(B); t=uint32(A.v)+uint32(B.v);
            SUM=RR_uint16(bitand(t,0xFFFFu32)); CARRY=RR_uint16(bitsrl(t,16)); 
        end
        function DIFF = minus(A,B)          % Define A-B
            A=RR_uint16.check(A); B=RR_uint16.check(B); Bbar=-B; DIFF=A+Bbar;
        end
        function OUT = uminus(B)            % Define -B
            B=RR_uint16.check(B); OUT=RR_uint16(bitcmp(B.v)+1);
        end    
        function [PROD,CARRY] = mtimes(A,B) % Define A*B (ignore CARRY for wrap on overflow)
            A=RR_uint16.check(A); B=RR_uint16.check(B); t=uint32(A.v)*uint32(B.v);
            PROD=RR_uint16(bitand(t,0xFFFFu32)); CARRY=RR_uint16(bitsrl(t,16));
        end
        function [QUO,RE] = mrdivide(B,A)   % Define [QUO,RE]=B/A  Note: use idivide, not /
            A=RR_uint16.check(A); B=RR_uint16.check(B);
            QUO=RR_uint16(idivide(B.v,A.v)); RE=RR_uint16(rem(B.v,A.v));
        end
        function POW = mpower(A,n),  p=uint64(A.v)^n;
            if p==0xFFFFFFFFFFFFFFFF, error('Overflow'), end, POW=RR_uint16(bitand(p,0xFFFFu64)); end    
        function FAC = factorial(A), f=uint64(1);      for i=2:A.v, f=f*uint64(i); end
            if f==0xFFFFFFFFFFFFFFFF, error('Overflow'), end, FAC=RR_uint16(bitand(f,0xFFFFu64)); end
        function n = norm(A), n=abs(A.v); end    % Defines norm(A)          
            
        % Now define A<B, A>B, A<=B, A>=B, A~=B, A==B based on the values of A and B.
        function tf=lt(A,B), A=RR_uint16.check(A); B=RR_uint16.check(B);
                             if A.v< B.v, tf=true; else, tf=false; end, end
        function tf=gt(A,B), A=RR_uint16.check(A); B=RR_uint16.check(B);
                             if A.v> B.v, tf=true; else, tf=false; end, end
        function tf=le(A,B), A=RR_uint16.check(A); B=RR_uint16.check(B);
                             if A.v<=B.v, tf=true; else, tf=false; end, end
        function tf=ge(A,B), A=RR_uint16.check(A); B=RR_uint16.check(B);
                             if A.v>=B.v, tf=true; else, tf=false; end, end
        function tf=ne(A,B), A=RR_uint16.check(A); B=RR_uint16.check(B);
                             if A.v~=B.v, tf=true; else, tf=false; end, end
        function tf=eq(A,B), A=RR_uint16.check(A); B=RR_uint16.check(B);
                             if A.v==B.v, tf=true; else, tf=false; end, end
        function s=sign(A),  if A.v==0,   s=0;     else, s=1;      end, end
    end
    methods(Static)
        function A=check(A)
            if isa(A,'numeric'), A=RR_uint16(A);
            elseif ~isa(A,'RR_uint16'), A=RR_uint16(A.v); end
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    methods(Access = protected)
        function displayScalarObject(OBJ)
            fprintf('RR_uint16 with value 0x%s = %d\n',dec2hex(OBJ.v,4),OBJ.v)
        end
    end
end